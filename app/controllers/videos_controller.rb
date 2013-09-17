class VideosController < ApplicationController
	def show
		authenticate_admin!
		@video = Video.find(params[:id])

		@manifest = @video.catch_manifest_data
	end

  def create
  	authenticate_admin!

  	Video.create(params[:video])
  	redirect_to action: :index, controller: :download
  end

  def destroy
    authenticate_admin!
    
    video=Video.find(params[:id])
    if video && video.destroy
      flash[:notice] = "Video gelöscht."
      redirect_to action: :index 
    else
      redirect_to action: :index
    end
  end
end
