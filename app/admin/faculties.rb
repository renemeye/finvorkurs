#encoding: utf-8
ActiveAdmin.register Faculty do
	show do |faculty|
      attributes_table do
        row :name
        row :short_name
      end

      panel pluralize faculty.degree_programs.count, "Degree Programs" do
        table_for faculty.degree_programs do |program|
          column :name
          column :degree
          column :his_id
        end
      end
    end

    form do |f|
    	f.inputs :faculty do
    		f.input :name
    		f.input :short_name
    	end
    	f.buttons
    	#f.inputs "Degree Programs" do
    		f.has_many :degree_programs do |program|
		        program.input :name
		        program.input :degree
		        program.input :his_id
		        if !program.object.nil?
		            program.input :_destroy, :as => :boolean, label: 'mehrere löschen'
		        end
	        end
    	#end
    	f.buttons
    end

end
