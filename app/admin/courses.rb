ActiveAdmin.register Course do
  config.filters = false 
  index do
    data = Course.all.collect{|course| [course.course_name, course.users.count]}
    para raw "<div  style=\"height: 300px; width:100%\" class=\"category_vizualisation\" data-bars='#{data.to_json}' data-yaxis_label='#Users'></div>"

    column :title
    column :fee
    column :from
    column :to
    column 'Enrollments' do |course|
      course.enrollments.count
    end
    column 'Present' do |course|
      course.users.to_a.count{|u|u.present}
    end
    default_actions
  end

  show do |course|
    attributes_table do
      row :title
      row :fee
      row :from
      row :to
    end

    panel pluralize course.enrollments.count, "Enrollment" do
      table_for course.enrollments do
        column :user
        column 'Group' do |enrollment|
          enrollment.group
        end
        column :created_at
      end
    end

  end

  form :html => { :enctype => "multipart/form-data" } do |f|  
    f.inputs "Kurs" do
      f.input :title
      f.input :course_level
    end

    f.inputs "Details" do
      f.input :description
      f.input :fee
    end

    f.inputs "Zeitraum" do
      f.input :from, :as => :datepicker
      f.input :to, :as => :datepicker
    end
    f.actions
  end

  action_item :only => :show do #, :if => proc{ Course.find(params[:id]).groups.each{|g| if g.users.count > 0; return false;  end };  return true } do
    link_to('Initialize Groups', :action => :initalize_groups)
  end

  member_action :initalize_groups do
    course = Course.find(params[:id])
    Group.initialize_groups_for_course(course)
    redirect_to({action: :show, id: params[:id]})
  end

end
