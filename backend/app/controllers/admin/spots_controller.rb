class Admin::SpotsController < Admin::BaseController
  before_action :set_spot, only: [:edit, :update, :destroy]

  def index
    @spots = Spot.includes(:address).page(params[:page]).per(params[:per_page])
  end

  def new
    @spot = Spot.new
    @spot.build_address
  end

  def create
    @spot = Spot.new(spot_params)
    @spot.user = current_user
    @spot.save
    respond_with :admin, @spot
  end

  def update
    @spot.update(spot_params)
    respond_with :admin, @spot
  end

  def destroy
    @spot.destroy
    respond_with :admin, @spot
  end

  private

  def set_spot
    @spot = Spot.includes(:address).find(params[:id])
  end

  def spot_params
    params.require(:spot).permit(:status, :name, :latitude, :longitude, new_photo_uploads_uuids: [],
                                 address_attributes: [:street, :city, :zip, :state, :country_code]
                                )
  end
end
