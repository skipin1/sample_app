# encoding: utf-8

include ApplicationHelper

def valid_signin(user)
  fill_in "Email",	with: user.email
  fill_in "Пароль",	with: user.password
  click_button "Вход в систему"
end

def sign_in(user)
  visit signin_path
  fill_in "Email",    with: user.email
  fill_in "Пароль", with: user.password
  click_button "Вход в систему"
  # Вход без Capybara.
  cookies[:remember_token] = user.remember_token
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end