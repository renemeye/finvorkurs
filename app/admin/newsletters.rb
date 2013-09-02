ActiveAdmin.register Newsletter do

	index do
    	selectable_column
    	id_column
    	column 'sent' do |newsletter|
	      if newsletter.sent?
	        b 'sent'
	      else
	        link_to 'not sent', send_newsletter_admin_newsletter_path(newsletter), method: :put
	      end
	  	end
    	column :subject
    	default_actions
    end

    member_action :send_newsletter, method: :put do
	    newsletter = Newsletter.find(params[:id])
	    newsletter.delay.deliver
	    redirect_to action: :index, notice: "Sent \"#{newsletter.subject}\""
   	end
end