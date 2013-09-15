class DownloadsController < ApplicationController
  def index
    @downloads = Download.all
    @upload = Download.new
  end

  def create
  	authenticate_tutor!

  	Download.create(params[:download])
  	redirect_to action: :index
  end
end
