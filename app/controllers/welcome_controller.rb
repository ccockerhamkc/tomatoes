class WelcomeController < ApplicationController
  def index
    if current_user
      @tomato = current_user.tomatoes.build
      @tomatoes = current_user.tomatoes.order_by([[:created_at, :desc]]).group_by do |tomato|
        date = tomato.created_at
        Time.mktime(date.year, date.month, date.day)
      end
    end
    
    count_query_opts = {
      :key => :user_id,
      :initial => {:count => 0},
      :reduce => "function(doc, prev) {prev.count += 1}"
    }

    @day_leaderboard = Tomato.ranking_today.slice(0, 10)
    @week_leaderboard = Tomato.ranking_this_week.slice(0, 10)
    @month_leaderboard = Tomato.ranking_this_month.slice(0, 10)
    @everytime_leaderboard = Tomato.ranking.slice(0, 10)
  end
end
