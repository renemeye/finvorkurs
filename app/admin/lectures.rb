ActiveAdmin.register Lecture do
	menu :parent => "Courses"  

	

	form :html => { :enctype => "multipart/form-data" } do |f|  
    f.inputs "Vorlesung" do
      f.input :name
      f.input :room
      f.input :description
      f.input :course
    end

    f.inputs "Zeitpunkt" do
      f.input :date, :as => :datepicker
    end
    f.actions
  end
end
