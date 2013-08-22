#encoding: utf-8
ActiveAdmin.register VorkursTest do
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
