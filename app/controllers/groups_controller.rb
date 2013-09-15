# encoding: utf-8
class GroupsController < ApplicationController
	def show
		@current_user = current_user
		@group = Group.find(params[:id])
		@tutor = @group.user
		return unless members_only!

		@is_tutor = (@current_user == @tutor || @current_user.admin?)
		respond_to do |format|
			format.html
			format.pdf do
				pdf = GroupPdf.new(@current_user, @group, @tutor, view_context)
				name = ActiveSupport::Inflector.transliterate @tutor.name.downcase.gsub(/\s/,"_")
				send_data pdf.render, filename: "unterschriften_#{name}.pdf", type: "application/pdf", disposition: "inline"
			end
		end
	end

	def edit
		@current_user = current_user
		@group = Group.find(params[:id])
		@tutor = @group.user

		return unless authenticate_tutor!
		return unless members_only!

		@is_tutor = (@current_user == @tutor || @current_user.admin?)
	end

	def update
		@group = Group.find(params[:id])
		return unless authenticate_tutor!
		return unless members_only!

    	if @group.update_attributes(params[:group])
    		redirect_to group_path(@group), :notice => "Gespeichert"
    	else
    		render :action => "edit"
    	end
	end

	private
	def members_only!
		if current_user.nil? || not(current_user.admin? || current_user == @group.user || @group.users.include?( current_user))
			redirect_to login_url, :notice => "Nur für Mitglieder der Gruppe!"
			return false
		end
		return true
	end
end