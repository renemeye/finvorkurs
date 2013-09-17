# encoding: utf-8
class VideosController < ApplicationController
	def show
		authenticate_admin!
		@video = Video.find(params[:id])

		@manifest = @video.catch_manifest_data
	end

  def create
  	authenticate_admin!

    begin
       Video.new.cardPresentationId params[:video][:mediaweb_url]
    rescue StandardError => e
      flash[:alert] = "Dies ist keine gültige Mediaweb URL. Sie sollte in etwa so aussehen: \"http://mediaweb.ovgu.de/Mediasite/Play/5e51df918a9d...\""
      redirect_to action: :index, controller: :downloads   
      return
    end 

  	Video.create(params[:video])
  	redirect_to action: :index, controller: :downloads
  end

  def destroy
    authenticate_admin!
    
    video=Video.find(params[:id])
    if video && video.destroy
      flash[:notice] = "Video gelöscht."
      redirect_to action: :index , controller: :downloads
    else
      redirect_to action: :index, controller: :downloads
    end
  end
end
