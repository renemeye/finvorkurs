ActiveAdmin.register Question do
	menu :parent => "VorkursTests"

    show do


      h3 question.text
      div do
        simple_format question.text
      end

      ul do
      	question.answers.each do |answer|
      		li answer.text
      	end
      end

    end

end
