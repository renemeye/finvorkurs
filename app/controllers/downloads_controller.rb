class DownloadsController < ApplicationController
  def index
  	authenticate_user!
    @downloads = Download.order("created_at DESC")
    @upload = Download.new
    @is_allowed_to_upload = current_user && current_user.role >= User::ROLES[:tutor]
  end

  def create
  	authenticate_tutor!

  	Download.create(params[:download])
  	redirect_to action: :index
  end
end
