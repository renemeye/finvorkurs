# encoding: utf-8
class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:new, :create, :index]
  before_filter :authenticate_admin!, :only => :index

  def index
    @users = User.all
  end

  def new
    @user = User.new
    respond_to { |format|
      format.html {}
      format.single {
        @format = "single"
      }
    }
  end

  def edit
    @user=@current_user 
		redirect_to root_url, :notice => "Keine Berechtigung. War das eventuell ein veralteter Link?" if @user.nil?
		check_permission!

		unless @user.email_confirmation
			flash[:notice] = "E-Mail-Adresse bestätigt."
			@user.email_confirmation = true
			@user.save
		end

		unless session[:user_id] == @user.id
			session[:user_id] = @user.id
			redirect_to edit_user_path @user.id
		end
  end

  def update
    params[:user].delete(:role) unless (!@current_user.nil? && params[:user][:role].to_i <= @current_user.role) || params[:user][:role].to_i <= User::ROLES[:registered]

    @user = User.find(params[:id])
    check_permission!
    if @user.update_attributes(params[:user])
      redirect_to root_url, :notice => "Daten geändert"
    else
      render :action => "edit"
    end
  end

  def create
    params[:user].delete(:role) unless (!@current_user.nil? && params[:user][:role].to_i <= @current_user.role) || params[:user][:role].to_i <= User::ROLES[:registered]

    @user = User.new(params[:user])
		@user.generate_token :preregistration_auth_token
    if @user.save
			@user.send_email_confirmation_mail
      send_notification_to_admins @user if Settings.administration.send_new_user_registered_notification
      url = (params[:redirect_to].nil?)? root_url : params[:redirect_to]["url"]
      redirect_to url, :notice => "Vielen Dank für ihr Interesse. Bitte sehen Sie in ihr Postfach und bestätigen Sie ihre E-Mail-Adresse."
    else
      render "new"
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user == current_user
      @user.destroy
      session.delete :user_id
	  redirect_to root_url, :notice => "Account gelöscht"
    elsif current_user.admin?
      @user.destroy
      redirect_to :users, :notice => "Account gelöscht"
    else
      exit
    end
  end

  private

  def check_permission!
    unless @user == current_user 
      abort "No Permission"
    end
  end

  def send_notification_to_admins user
    admins = User.find_all_by_role User::ROLES[:admin]
    admins.each do |a|
      a.send_new_user_notification user
    end
  end

	def get_user_by_id_or_auth_token id_or_token
    user = User.find_by_preregistration_auth_token(id_or_token)
		if user.nil?
			user = User.find_by_id(id_or_token)
		end
	end
end
