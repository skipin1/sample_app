# encoding: utf-8

require 'spec_helper'

describe "Страница Пользователя:" do
  
  subject { page }

  describe "на странице index" do
    let(:user) { FactoryGirl.create(:user) }

    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_selector('title', text: "Пользователи") }
    it { should have_selector('h1', text: "Все пользователи") }

    describe "пагинация," do
      before(:all)  { 30.times { FactoryGirl.create(:user) } }
      after(:all)   { User.delete_all }

      it { should have_selector('div.pagination') }

      it "должен быть список со всеми пользователями" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end

    describe "ссылки delete" do
      it { should_not have_link('delete') }

      describe "в качестве пользователя admin" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('Удалить', href: user_path(User.first)) }
        it "должен быть в состоянии удалить другого пользователя" do
          expect { click_link('Удалить') }.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

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
        fill_in "Имя",            with: "Example user"
        fill_in "Email",          with: "user@example.com"
        fill_in "Пароль",         with: "foobar"
        fill_in "Подтверждение",  with: "foobar"
      end

  		it "ДОЛЖНА создать пользователя" do
  			expect {click_button submit}.to change(User, :count).by(1)
  		end

      describe "после сохранения пользователя" do
        before {click_button submit}
        let(:user) {User.find_by_email('user@example.com')}

        it { should have_selector('title', text: user.name ) }
        it { should have_selector('div.alert.alert-success',text: user.name) }
        it { should have_link('Выход') }
      end
  	end
  end

  describe "при редактировании профиля пользователя" do
    let(:user){ FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "страница" do
      it { should have_selector('h1', text: "Обновление вашего профиля") }
      it { should have_selector('title', text: "Редактирование пользователя") }
      it { should have_link('изменить', href: 'http://gravatar.com/emails') }
    end

    describe "с не правильной введенной информацией" do
      before { click_button "Сохранить изменения" }
      it { should have_content('ошибка') }
    end

    describe "с правильно введенными данными" do
      let(:new_name)  { "Новое имя" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Имя",                    with: new_name
        fill_in "Email",                  with: new_email
        fill_in "Введите новый пароль",   with: user.password
        fill_in "Подтверждение пароля",   with: user.password
        click_button "Сохранить изменения"
      end

      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Выход', href: signout_path) }
      specify { user.reload.name.should == new_name }
      specify { user.reload.email.should == new_email }
    end
  end
end