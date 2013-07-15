# encoding: utf-8

require 'spec_helper'

describe "Static pages:" do

	let(:base_title) {"Ruby on Rails Tutorial Sample App"}

  describe "Главная" do

    it "должна содержать тэг h1 'Главная'" do
      visit '/static_page/home'
      page.should have_selector('h1', text: "Главная")
    end

		it "должна содержать тэг title 'Главная'" do
			visit '/static_page/home'
			page.should have_selector('title', text: "#{base_title} | Главная")
		end
	end

  describe "Страница Help" do

  	it "должна содержать h1 тэг 'Помощь'" do
  		visit '/static_page/help'
  		page.should have_selector('h1', text: "Помощь")
  	end

  	it "должна содержать тэг title 'Помощь'" do
  		visit '/static_page/help'
  		page.should have_selector('title', text: "#{base_title} | Помощь")
  	end
  end

  describe "Страница О нас" do

  	it "должна содержать h1 тэг 'О нас'" do
  		visit '/static_page/about'
  		page.should have_selector('h1', text: "О нас")
  	end

  	it "должна содержать тэг title 'О нас'" do
  		visit '/static_page/about'
  		page.should have_selector('title', text: "#{base_title} | О нас")
  	end
	end

	describe "Страница Контакты" do

  	it "должна содержать h1 тэг 'Контакты'" do
  		visit '/static_page/contact'
  		page.should have_selector('h1', text: "Контакты")
  	end

  	it "должна содержать основной заголовок сайта" do
      visit '/static_page/contact'
      page.should have_selector('title', text: "#{base_title}")
    end

  	it "должна содержать тэг title 'Контакты'" do
  		visit '/static_page/contact'
  		page.should have_selector('title', text: "#{base_title} | Контакты")
  	end
	end
end
