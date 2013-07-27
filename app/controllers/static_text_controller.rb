class StaticTextController < ApplicationController
  respond_to :json
  #before_filter :authenticate_admin!

  def index
    @static_texts = StaticText.order :created_at
  end

  def show
    @static_text = StaticText.find(params[:id])
    respond_with @static_text
  end

  def new
    @static_text = StaticText.new
  end

  def edit
    @static_text = StaticText.find(params[:id])
  end

  def create
    @static_text = StaticText.new(params[:static_text])

    if @static_text.save
      redirect_to static_texts_path, :notice => 'Text gespeichert'
    else
      render :action => "new"
    end
  end

  def update
    @static_text = StaticText.find(params[:id])
    respond_to do |format|
      if @static_text.update_attributes(params[:static_text])
        #format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.json { respond_with_bip(@static_text) }
      else
        #format.html { render :action => "edit" }
        format.json { respond_with_bip(@static_text) }
      end
    end

  end

  def destroy
    @static_text = StaticText.find(params[:id])
    @static_text.destroy

    redirect_to static_texts_path, :notice => 'Text gel&ouml;scht'
  end

end
