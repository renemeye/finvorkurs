ActiveAdmin.register VorkursTest do
	show do |vorkurs_test|
		attributes_table do
	        row :id
	        row :name
	        row (:description){|vorkurs_test| raw(vorkurs_test.markdown_description)}
	    end

	end  
end
