# encoding: utf-8

ActiveAdmin.register Question do
	menu :parent => "Vorkurs Tests"

    index do 
      html raw "<script>$(function(){MathJax=null;})</script>"

      selectable_column
      column :id
      column :category if Settings.vorkurs_test.categorized_question
      column :text
      column :question_type do |question|
        question.readable_type
      end
      column :test do |question|
        question.vorkurs_test.name
      end
      default_actions
    end

    show do |question|
      attributes_table do
        row :vorkurs_test
        row (:question_type){|question| question.readable_type }
        row :category if Settings.vorkurs_test.categorized_question
        row  (:text){|question| raw(question.markdown_text)}
        row (:false_answer_explanation){|question| raw(question.markdown_false_answer_explanation)}
      end

      panel pluralize question.answers.count, "Answers" do
        table_for question.answers do |answer|
          column (:text){|question| raw(question.text)}
          column :correct
          column (:false_answer_explanation){|question| raw(question.false_answer_explanation)}
        end
      end
    end

    action_item :only => :show do
      link_to 'Create Question', :action => 'new'
    end

    action_item :only => :index do
      link_to 'Preview Questions', overview_questions_path
    end

    action_item :only => :index do
      link_to 'Import Questions', :action => 'upload_json'
    end

    action_item :only => :index do
      link_to 'Export Questions', :action => 'download', :format => :json
    end

    collection_action :upload_json do
      render "admin/json/upload_json"
    end

    collection_action :download do
      questions = Question.all
      respond_to do |format|
        format.json {
          send_data questions.to_json, filename: "#{Time.new.strftime("%Y_%m_%d_%R")}_questions.json"
        }
      end
    end

    collection_action :import_json, :method => :post do
      #CsvDb.convert_save("post", params[:dump][:file])
      uploaded_io = params[:dump][:file]
      if uploaded_io.is_a?(ActionDispatch::Http::UploadedFile)
        file_data = uploaded_io.tempfile
        File.open(file_data, 'r') do |file|  
          file.each do |line|
            questions = JSON.parse line
            questions.each do |raw_question|
              raw_question.delete("id")
              raw_question.delete("created_at")
              raw_question.delete("updated_at")

              answers = raw_question["answers"].clone
              raw_question.delete("answers")

              question = Question.create raw_question

              answers.each do |raw_answer|
                raw_answer.delete("id")
                raw_answer.delete("created_at")
                raw_answer.delete("updated_at")

                answer = Answer.create(raw_answer)
                question.answers << answer
              end
              question.save
            end
          end
        end
      end
      redirect_to :action => :index, :notice => "JSON imported successfully!"
    end



    #Edit form
    form do |f|
      f.inputs 'question' do
        f.input :vorkurs_test
        f.input :question_type, as: :select, collection: Hash[Question::TYPES.map{|k,v| [Question::TYPE_NAMES[v],v]}], :include_blank => false
        f.input :category if Settings.vorkurs_test.categorized_question
        f.input :text, :input_html => { :rows => 4}
        f.input :false_answer_explanation, :input_html => { :rows => 4}
      end

      f.has_many :answers do |answer|
       # answer.inputs do
          answer.input :text
          answer.input :false_answer_explanation, :input_html => { :rows => 4}
          answer.input :correct, label: 'korrekte Antwort'
          if !answer.object.nil?
            answer.input :_destroy, :as => :boolean, label: 'mehrere löschen'
          end
      #  end
      end
      f.buttons
    end

end
