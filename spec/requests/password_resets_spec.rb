require 'spec_helper.rb'

describe "PasswordResets" do

  it "emails user when requesting password reset" do
  	user = create(:user)
    visit "/login"
    click_link "vergessen"

    #Send to my E-Mail
    fill_in "email", :with => user.email
    click_button "Sende"

    #Got right flash message?
    #current_path.should eq(root_url)
    page.should have_content("E-Mail mit Anweisungen gesendet")

    #Sent E-Mail correctly?
    last_email.to.should include(user.email)
  end
end
