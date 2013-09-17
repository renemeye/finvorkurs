class VideoController < ApplicationController
	def show
		authenticate_user!
		@video = Video.find(params[:id])

		@manifest = @video.catch_manifest_data
	end
end
