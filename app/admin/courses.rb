ActiveAdmin.register Course do
  config.filters = false 
  index do |course|
    column :title
    column :fee
    column :from
    column :to
    column 'Enrollments' do |course|
      course.enrollments.count
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

end
