# encoding: utf-8
class EnrollmentsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  def new
    @course = Course.find(params[:course_id])
    @user = current_user
    @enrollment = Enrollment.new
  end

  def create
    @course = Course.find(params[:course_id])
    @user = current_user
    if @user.courses << @course && @user.update_attributes(params[:user])
      @user.send_enrollment_confirmation @course
      Log.new(message: "#{@user.name} enrolled to #{@course.title}").save
      redirect_to courses_path, :notice => "Ihre Kursanmeldung war erfolgreich. Sie erhalten eine Bestätigung per E-Mail"
    else
      @user.courses.delete @course
      @enrollment = Enrollment.new
      render "new"
    end
  end

  def destroy
    @enrollment = Enrollment.find params[:id]
    @enrollment.status = Enrollment::STATES[:unregistered]
    if @enrollment.save
      Log.new(message: "#{current_user.name} cancelled #{@enrollment.course.title}").save
      redirect_to edit_user_path(current_user), :notice => "Abmeldung erfolgreich"
    end
  end


  def create_multiple
    @course_levels = params[:course_ids];
    @user = current_user
    @title = ""    

    unless @course_levels.nil?
      @course_levels.each do |course_level, course_id|
        @course = Course.find(course_id[0].to_i);
        if (not @user.courses.include?(@course)) && @user.courses << @course
          @title = (@title == "")? "#{@course.course_name}": "#{@title} und #{@course.course_name}"

          @user.send_enrollment_confirmation @course
          Log.new(message: "#{@user.name} enrolled to #{@course.course_name}").save
        end
      end
    end

    unless @title == ""
      redirect_to root_url, :notice => "Ihre Kursanmeldung zum #{@title} war erfolgreich. Sie erhalten eine Bestätigung per E-Mail."
    else
      redirect_to root_url, :notice => "Etwas ist schief gegangen. Leider konnten wir Sie für keinen Kurs anmelden. Melden sie sich bitte bei #{Settings.mail.from}."
    end

  end

end
