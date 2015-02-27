class UploadsController < ApplicationController

  def new
    render json: UploadPresigner.new.data
  end

  def create
  end
end
