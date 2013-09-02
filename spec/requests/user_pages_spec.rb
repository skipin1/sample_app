# encoding: utf-8

require 'spec_helper'

describe "Страница Пользователя:" do
  subject { page }

  describe "страница регистрации должна иметь правильные аттрибуты" do
  	before { visit signup_path }

    it { should have_selector('h1', text: "Регистрация")}
    it { should have_selector('title', text: "Регистрация")}
  end

  describe "стриница профиля должна иметь правильные аттрибуты" do
  	let(:user) { FactoryGirl.create(:user) }
  	before { visit user_path(user)}

  	it {should have_selector('h1',		text: user.name)}
  	it {should have_selector('title',	text: user.name)}
  end

  describe "при регистрации" do
  	before { visit signup_path }
  	let(:submit) {"Создать пользователя"}

  	describe "с НЕ правильной информацией о пользователе" do
  		it "НЕ ДОЛЖНА создавать пользователя" do
  			expect {click_button submit}.not_to change(User, :count)
  		end
  	end

    describe "после нажатия СОЗДАТЬ" do
        before {click_button submit}

        it {should have_selector('h1', text: 'Регистрация')}
        it {should have_content('ошибка')}
      end

  	describe "с правильной информацией о пользователе" do
  		before do
  			fill_in "Имя",						with: "Example user"
  			fill_in "Email",					with: "user@example.com"
  			fill_in "Пароль",					with: "foobar"
  			fill_in "Подтверждение",	with: "foobar"
  		end

  		it "ДОЛЖНА создать пользователя" do
  			expect {click_button submit}.to change(User, :count).by(1)
  		end

      describe "после сохранения пользователя" do
        before {click_button submit}
        let(:user) {User.find_by_email('user@example.com')}

        it {should have_selector('title', text: user.name )}
        it {should have_selector('div.alert.alert-success',text: user.name)}
        it { should have_link('Выход') }
      end
  	end
  end
end