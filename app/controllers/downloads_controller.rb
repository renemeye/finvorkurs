# encoding: utf-8
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

  def destroy
    authenticate_tutor!
    download=Download.find(params[:id])
    if download && download.destroy
      flash[:notice] = "#{download.name} gelöscht."
      redirect_to action: :index 
    else
      redirect_to action: :index
    end
  end
end
