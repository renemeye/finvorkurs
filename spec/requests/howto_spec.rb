require 'spec_helper.rb'

describe "howto" do

  describe "login_logout" do
    it "is possible to login and logout" do
      user = create(:user)

      visit root_url
      page.should have_content("Neuen Account erstellen")
      page.should have_content("Vorregistriert, aber noch kein Passwort?")

      login_as user
      visit root_url
      page.should have_content(user.email)

      logout_user
      visit root_url
      page.should_not have_content(user.email)
    end
  end

  it "shows Hallo only for registered user with name" do
  	user = create(:user)
    login_as user

    visit root_url
    page.should_not have_content("Neuen Account erstellen")
    page.should_not have_content("Vorregistriert, aber noch kein Passwort?")
    page.should have_content("Hallo,")

    a_name = "Paul Riegel"

    user.name = a_name
    user.save
    visit root_url
    page.should have_content("Hallo #{a_name},")
  end
end
