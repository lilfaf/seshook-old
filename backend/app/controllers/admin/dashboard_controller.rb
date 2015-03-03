module Admin
  class DashboardController < Admin::BaseController
    def index
      @latest_spots = Spot.includes(:address).pending.recent(10)
      @latest_users = User.recent(10)
    end

    def chart_data
      days = params.fetch(:days, 30)
      render json: AdminChart.new(days).stats_for([Spot, User]).chart_json
    end
  end
end
