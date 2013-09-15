class DownloadsController < ApplicationController
  def index
    @downloads = Download.order("created_at DESC")
    @upload = Download.new
  end

  def create
  	authenticate_tutor!

  	Download.create(params[:download])
  	redirect_to action: :index
  end
end
