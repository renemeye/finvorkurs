#encoding: utf-8
ActiveAdmin.register Faculty do

  index do |faculty|

    data = Faculty.all.collect{|f| [f.short_name, f.users.count]}
    para raw "<div  style=\"height: 300px; width:100%\" class=\"category_vizualisation\" data-bars='#{data.to_json}' data-yaxis_label='#Users'></div>"

    column :name
    column :short_name
    default_actions
  end

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
