ActiveAdmin.register StaticText do

	index do 
		column :key
		column :value
		default_actions
	end

	actions :all, :except => [:new]

	action_item :only => :index do
      link_to 'Import Texts', :action => 'upload_json'
    end

    action_item :only => :index do
      link_to 'Export Texts', :action => 'download', :format => :json
    end

    collection_action :upload_json do
      render "admin/json/upload_json"
    end

    collection_action :download do
      static_texts = StaticText.all
      respond_to do |format|
        format.json {
          send_data static_texts.to_json, filename: "#{Time.new.strftime("%Y_%m_%d_%R")}_static_texts.json"
        }
      end
    end

    collection_action :import_json, :method => :post do
      #CsvDb.convert_save("post", params[:dump][:file])
      uploaded_io = params[:dump][:file]
      if uploaded_io.is_a?(ActionDispatch::Http::UploadedFile)
      	StaticText.all.each{|s|s.destroy}
        file_data = uploaded_io.tempfile
        File.open(file_data, 'r') do |file|  
          file.each do |line|
            static_texts = JSON.parse line
            static_texts.each do |raw_static_text|
              raw_static_text.delete("id")
              raw_static_text.delete("created_at")
              raw_static_text.delete("updated_at")

              static_text = StaticText.create raw_static_text
              static_text.save
            end
          end
        end
      end
      redirect_to :action => :index, :notice => "JSON imported successfully!"
    end
end