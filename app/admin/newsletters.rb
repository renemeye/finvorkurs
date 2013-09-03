#Encoding: utf-8
ActiveAdmin.register Newsletter do
	menu :parent => "Users"

  form do |f|
    f.inputs "Newsletter (Der Newsletter wird nicht direkt gesendet.)" do
      f.input :subject
      f.input :content
    end
    f.inputs "Select Receivers" do
    	f.input :all_users, as: :boolean
   		f.input :no_degree_programs, as: :boolean, label: "User die sich für keinen Studiengang interessieren"
    end

    f.inputs "Receivers from specific Degreeprograms" do
    	size = Faculty.count+DegreeProgram.count
   		f.grouped_collection_select :degree_program_ids, Faculty.order(:name), :degree_programs, :name, :id, :name_and_degree, {}, {multiple: true, :size => size}

	end
    f.actions
  end

	index do
    	selectable_column
    	id_column
    	column 'sent' do |newsletter|
	      if newsletter.sent?
	      	if newsletter.delivered_at.nil?
	      		para "Sent"
	      	else
	      		if newsletter.delivered_at.today?
	      			para "Gesendet um #{newsletter.delivered_at.strftime("%H:%M Uhr")}"
	      		else
			        para "Gesendet am #{newsletter.delivered_at.strftime("%d.%m.%Y um %H:%M Uhr")}"
			    end
		    end
	      elsif newsletter.sending?
	      	b "Sending #{number_to_percentage(newsletter.done_percentage, :precision => 1)}"
	      else
	        link_to 'Send now!', send_newsletter_admin_newsletter_path(newsletter), method: :put, class: "btn"
	      end
	  	end
    	column :subject
    	default_actions
    end

  	show do |newsletter|
    	attributes_table do
			row :subject
			row :content
			row 'Receivers (if sent now)' do
				columns do
      				column do
		        		ul do
		        			div "Total amount of receivers: #{newsletter.all_receivers.count}"
			      			newsletter.degree_programs.each do |program|
			        			li "#{program.name} (#{program.faculty.short_name}) | #{program.users.count} Users"
			          		end
		        		end
		        	end
		        	column do
		        		h5 "List of Users receiving this Newsletter"
		        		ul do
		        			newsletter.all_receivers.each do |user|
		        				li "#{user.email} #{user.degree_programs.collect{|d|d.name}}"
		        			end
		        		end
		        	end
		        end
  			end
  			row 'Status' do
	     		if newsletter.sent?
			      	if newsletter.delivered_at.nil?
			      		para "Sent"
			      	else
			      		if newsletter.delivered_at.today?
			      			para "Gesendet um #{newsletter.delivered_at.strftime("%H:%M Uhr")}"
			      		else
					        para "Gesendet am #{newsletter.delivered_at.strftime("%d.%m.%Y um %H:%M Uhr")}"
					    end
				    end
			    elsif newsletter.sending?
			      	b "Sending #{number_to_percentage(newsletter.done_percentage, :precision => 1)}"
			    else
			        link_to 'Send now!', send_newsletter_admin_newsletter_path(newsletter), method: :put, class: "btn"
			    end
	  		end
    	end
	end

    member_action :send_newsletter, method: :put do
	    newsletter = Newsletter.find(params[:id])
	    
	    newsletter.state = "sending"
	    newsletter.save

	    newsletter.delay.deliver

	    flash[:notice] = "Started delivering \"#{newsletter.subject}\""
	    redirect_to action: :index
   	end
end


