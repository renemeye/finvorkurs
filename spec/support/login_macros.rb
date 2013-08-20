module LoginMacros
	def login_as(user)
		page.set_rack_session(:user_id => user.id) if user
	end

	def logout_user
		page.set_rack_session(:user_id => nil)
	end
end