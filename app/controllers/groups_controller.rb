class GroupsController < ApplicationController
	def show
		@current_user = current_user
		@group = Group.find(params[:id])
		@tutor = @group.user
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

		if not(@current_user == @tutor) && not(@current_user.admin?)
	    	redirect_to({controller: "home", action: :index})
	    	return
	    end
		@is_tutor = (@current_user == @tutor || @current_user.admin?)
	end

	def update
		@group = Group.find(params[:id])
	    if not(current_user == @group.user) && not(current_user.admin?)
	    	redirect({action: :show, id: @group.id})
	    	return
	    end

    	if @group.update_attributes(params[:group])
    		redirect_to group_path(@group), :notice => "Gespeichert"
    	else
    		render :action => "edit"
    	end
	end
end