ActiveAdmin.register Question do
	menu :parent => "Vorkurs Tests"

    show do
      
      h3 question.text
      div do
        simple_format question.text
      end

      div do
        simple_format question.false_answer_explanation
      end      

      ul do
      	question.answers.each do |answer|
      		li answer.text
      	end
      end

    end

end
