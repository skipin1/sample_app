# encoding: utf-8

require 'spec_helper'

describe "Static pages:" do

  subject {page}
	#let(:base_title) {"Ruby on Rails Tutorial Sample App"}

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_selector('title', text: full_title(page_title)) }
  end
  
  describe "Главная" do
    before { visit root_path }
    let(:heading)     { 'Главная' }
    let(:page_title)   { 'Главная' }

    it_should_behave_like "all static pages"
    it { should_not have_selector 'title', text: 'Home' }

	end

  describe "Страница Помощь" do
    before { visit help_path }
    let(:heading)     { 'Помощь' }
    let(:page_title)   { 'Помощь' }

  	it_should_behave_like "all static pages"
    it { should_not have_selector 'title', text: 'Help' }
  end

  describe "Страница О нас" do
    before { visit about_path }
    let(:heading)     { 'О нас' }
    let(:page_title)   { 'О нас' }


  	it_should_behave_like "all static pages"
    it { should_not have_selector 'title', text: 'About' }
	end

	describe "Страница Контакты" do
    before { visit contact_path }
    let(:heading)     { 'Контакты' }
    let(:page_title)   { 'Контакты' }

  	it_should_behave_like "all static pages"
    it { should_not have_selector 'title', text: 'Contact' }
	end

  it "правильные ссылки в шаблонах" do
    visit root_path

    click_link "About"
    page.should have_selector 'title', text: full_title('О нас')

    click_link "Помощь"
    page.should have_selector 'h1', text: 'Помощь'
    
    click_link "Contact"
    page.should have_selector 'title', text: full_title('Контакты')

    click_link "Главная"
    click_link "Sign up now!"
    page.should have_selector 'h1', text: 'Регистрация'

    # click_link "sample app"
    # page.should # fill in
  end
end
