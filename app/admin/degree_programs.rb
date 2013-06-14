ActiveAdmin.register DegreeProgram do

 	controller do
    def scoped_collection
      resource_class.includes(:users) 
    end
  end

	index do
		column :name
		column :degree

		default_actions
	end

  show do |degree_program|
    attributes_table do
      row :id
      row :name
			row :faculty
			row :degree
			row :his_id
      row :created_at
      row 'Users' do
				if degree_program.users.count == 0
					"Not selected!" 
				else
					ul do
						degree_program.users.each do |t|
							li link_to "User: #{t.email}", :controller => "users", :action => "show", :id => t.id
						end
					end
				end
      end
    end
  end


  
end
