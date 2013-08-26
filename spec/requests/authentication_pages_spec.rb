# encoding: utf-8

require 'spec_helper'

describe "Авторизация" do
	subject {page}  

	describe "страница ВХОДА" do
		before {visit signup_path}

		it {should have_selector('h1', tetx:"Вход на сайт")}
		it {should have_selector('title', tetx:"Вход на сайт")}
	end
end
