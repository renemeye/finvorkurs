ActiveAdmin.register User do
  menu priority: 2
  filter :id
  filter :email
  filter :name
  filter :present, as: :select
  filter :paid, as: :select

  member_action :pay, method: :put do
    user = User.find(params[:id])
    user.paid = !user.paid
    user.present = true
    user.save!
    redirect_to({action: :index}, notice: (user.paid? ? "#{user.name} set paid and present" : "#{user.name} set not paid"))
  end

  member_action :present, method: :put do
    user = User.find(params[:id])
    user.present = !user.present
    user.save!
    redirect_to({action: :index}, notice: (user.present? ? "#{user.name} is present" : "#{user.name} is not present"))
  end

  csv do
    column :name
    column :email
    column "Courses" do |user|
      user.courses.count
    end
    column 'Present' do |user|
      user.present?
    end

    VorkursTest.all.each do |test|
      column "#{test.name} result in prz" do |user|
        if user.completed_test? test
          user.test_result(test)
        elsif user.started_test? test
          "not finished"
        else
          "-"
        end

      end

      column "#{test.name} duration (first to last answer)" do |user|
        if user.started_test? test
          start_end = user.test_duration test;
          ((start_end[1]-start_end[0])/1.minute).round
        else
          "-"
        end
      end
    end
  end


  index do
    h2 do
      money = User.all.inject(0) do |sum, user|
        sum += if user.paid? then user.enrollments.count * 10 else 0 end
      end 
      "#{money} EUR"
    end

    selectable_column
    id_column
    column :name
    column :email
    column "Courses" do |user|
      user.courses.count
    end
    column 'Present' do |user|
      if user.present?
        link_to 'present', present_admin_user_path(user), method: :put
      else
        link_to 'not present', present_admin_user_path(user), method: :put
      end
    end

    VorkursTest.all.each do |test|
      column "#{test.name}" do |user|
        if user.completed_test? test
          number_to_percentage(user.test_result(test), precision: 1) 
        elsif user.started_test? test
          "not finished"
        else
          "-"
        end

      end

      column "#{test.name}" do |user|
        if user.started_test? test
          start_end = user.test_duration test;
          distance_of_time_in_words(start_end[0],start_end[1]);
        else
          "-"
        end
      end
    end

    column 'Paid' do |user|
      if user.paid?
        link_to 'paid', pay_admin_user_path(user), method: :put
      else
        link_to 'not paid', pay_admin_user_path(user), method: :put
      end
    end
    default_actions
  end 

  show do |user|
    attributes_table do
      row :id
      row :email
      row :name
      row :created_at
      row 'Test Results' do
        ul do
          user.test_results.each do |t|
            li "#{t.course.title} #{t.score}%"
          end
        end
      end

			row "Interested in Degree Programs" do
				if user.degree_programs.count == 0
					"No specified degree programs."
				else
					ul do
						user.degree_programs.each do |program|
							li link_to "#{program.name} (#{program.degree})", :action=>"show", :controller=>"degree_programs", :id=>program.id
						end
					end
				end
			end

      row "Enrollments" do
        ul do
          user.enrollments.each do |enrollment|
            li enrollment.course.title
          end
        end
      end
    end
  end

  form do |f|
    f.inputs "User" do
      f.input :email
      f.input :name
      f.input :password
      f.input :password_confirmation
      f.input :role, as: :select, collection: User::ROLES, :hint => "Unless preregistered is chosen, the user need to have a password.", :include_blank => false
    end
    f.actions
  end
end
