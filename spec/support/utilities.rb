include ApplicationHelper

def sign_in_devise(user, options={})
	if options[:no_capybara]
		remember_token = User.new_remember_token
		cookies[:remember_token] = remember_token
		user.update_attribute(:remember_token, User.encrypt(remember_token))
	else
		visit new_user_session_path
		fill_in 'user_email', with: user.email
		fill_in 'user_password', with: user.password
		click_button "Sign in"
	end
end

def sign_up
	visit new_user_registration_path
	fill_in :user_email, with: 'me@example.com'
	fill_in :user_password, with: 'password'
	fill_in :user_password_confirmation, with: 'password'
	click_button 'Sign up'
end

def puts_debug(example, *input)
	puts "start of #{example.metadata[:full_description]} block"
	puts input.to_yaml
	puts "------------------------------"
end