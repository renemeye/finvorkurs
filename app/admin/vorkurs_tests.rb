#encoding: utf-8
ActiveAdmin.register VorkursTest do

	index do
		selectable_column
    	id_column
    	column :name
    	column :description
    	default_actions

		 panel "Test results" do
          h5 "Test result Histogram:"
          test_result_histogram = VorkursTest.all.collect do |vorkurs_test|
            counter = [[100,0],[90,0],[80,0],[70,0],[60,0],[50,0],[40,0],[30,0],[20,0],[10,0]]
            User.all.each do |user|
              if user.completed_test? vorkurs_test
                result = vorkurs_test.result user
               # if result > 0
                  counter.each do |c|
                    if result >= c[0]
                      c[1] = c[1]+1
                      break
                    end
                  end
                #end
              end
            end
            counter.reverse!
          end


          para raw "<div  style=\"height: 300px; width:100%\" class=\"multiple_category_vizualisation\" data-bars='#{test_result_histogram.to_json}'></div>"
        end
	end

	show do |vorkurs_test|
		attributes_table do
	        row :id
	        row :name
	        row (:description){|vorkurs_test| raw(vorkurs_test.markdown_description)}
	    end

	    panel pluralize vorkurs_test.recomendations.count, "Recomendations" do
	        table_for vorkurs_test.recomendations do |recomendation|
	          column "We recomend", :course_level
	          column "if this tests result is less than (percent)", :min_percentage, "%"
	        end
	    end
	end  

	form do |f|
	    f.inputs 'Vorkurs Test' do
	        f.input :name
	        f.input :description
		end
		f.has_many :recomendations do |recomendation|
	    	recomendation.input :course_level, as: :select, collection: Course.course_levels, include_blank: false, hint: "We recomend"
	       	recomendation.input :min_percentage, hint: "if this tests result is less than (percent)"
	       	if !recomendation.object.nil?
            	recomendation.input :_destroy, :as => :boolean, label: 'mehrere löschen'
          	end
	    end
	    f.buttons
	end
end
