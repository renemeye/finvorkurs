# encoding: utf-8

ActiveAdmin.register Question do
	menu :parent => "Vorkurs Tests"

    show do |question|
      attributes_table do
        row :vorkurs_test
        row :text
        row :false_answer_explanation
      end

      panel pluralize question.answers.count, "Answers" do
        table_for question.answers do |answer|
          column :text
          column :correct
        end
      end

    end


    #Edit form
    form do |f|
      f.inputs 'question' do
        f.input :vorkurs_test
        f.input :text
        f.input :false_answer_explanation
      end

      f.has_many :answers do |answer|
       # answer.inputs do
          answer.input :text
          answer.input :correct, label: 'korrekte Antwort'
          if !answer.object.nil?
            answer.input :_destroy, :as => :boolean, label: 'mehrere löschen'
          end
      #  end
      end
      f.buttons
    end

end
