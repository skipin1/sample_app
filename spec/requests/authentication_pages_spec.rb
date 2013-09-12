# encoding: utf-8

require 'spec_helper'

describe "Аутентификация:" do
	subject {page}  

	describe "страница ВХОДА" do
		before {visit signin_path}

		# Проверяем наличие стандартных атрибутов на странице
		it { should have_selector('h1', text:"Вход в систему") }
		it { should have_selector('title', text: "Вход в систему") }

		# Проверяем реакцию на НЕ правильные данные
		describe "с введенными не правильными данными" do
			before {click_button "Вход в систему"}

			it { should have_selector('title', text: "Вход в систему") }
			it { should have_selector('div.alert.alert-error',  text: "Не верная комбинация логин/пароль") }

			describe "посещение другой страницы после отправки логина/пароля" do
				before { click_link "Главная" }
				it { should_not have_selector('div.alert.alert-error') }
			end
		end

		# Проверяем реакцию на ПРАВИЛЬНЫЕ данные
		describe "с введенными правильными данными" do
			let (:user) { FactoryGirl.create(:user) }

			before { sign_in user }

			it { should have_selector('title', text: user.name) }

			it { should have_link('Пользователи', href: users_path) }
			it { should have_link('Профиль', href: user_path(user)) }
			it { should have_link('Настройки', href: edit_user_path(user)) }
			it { should have_link('Выход', href: signout_path) }

			it { should_not have_link('Вход', href: signin_path) }

			describe "с последующим выходом" do
        before { click_link "Выход"}
        it { should have_link('Вход') }
        it { should have_selector('div.alert.alert-notice') }
      end
		end
	end

	describe "авторизация" do

		describe "для неавторизованного пользователя" do
			let(:user) { FactoryGirl.create(:user) }

			describe "при попытке посетить защищенную страницу," do
				before do
					visit edit_user_path(user)
					fill_in "Email", 	with: user.email
					fill_in	"Пароль",	with: user.password
					click_button	"Вход в систему"
				end

				describe "после авторизации" do

					it "система должна перенаправить на запрашиваемую страницу" do
						page.should have_selector('title', text: "Редактирование")
					end					
				end
			end

			describe "в контроллере Users," do

				describe "посещение страницы редактирования" do
					before { visit edit_user_path(user) }

					it { should have_selector('title', text: "Вход в систему") }
				end

				describe " отправка данных в update action" do
					before { put user_path(user) }
					specify { response.should redirect_to(signin_path) }
				end

				describe "посещение страницы User#index action" do
					before { visit users_path }
					it { should have_selector('title', text: "Вход в систему") }
				end
			end
		end

		describe "как НЕПРАВИЛЬНЫЙ ;) пользователь" do
			let(:user) { FactoryGirl.create(:user) }
			let(:wrong_user) { FactoryGirl.create(:user, email: "test@test.ru") }
			before {sign_in user}

			describe "посещение User#edit страницу" do
				before { visit edit_user_path(wrong_user) }
				it { should_not have_selector('title', text: full_title('Редактиование пользователя')) }
			end

			describe "отправка запроса PUT методом к User#update action" do
				before { put user_path(wrong_user) }
				specify { response.should redirect_to edit_user_path(user) }
			end
		end

		describe "как НЕ администратор" do
			let(:user)			{ FactoryGirl.create(:user) }
			let(:non_admin)	{ FactoryGirl.create(:user) }

			before { sign_in non_admin }

			describe "запрос на удаление в Users#destroy action" do
				before { delete user_path(user) }
				specify { response.should redirect_to(root_path) }
			end
		end
	end
end