# encoding: utf-8

require 'spec_helper'

describe "Static pages:" do

	let(:base_title) {"Ruby on Rails Tutorial Sample App"}
  subject {page}

  describe "Главная" do
    before { visit root_path }

    it { should have_selector('h1', text: "Главная") }

		it { should have_selector('title', text: full_title('Главная')) }
	end

  describe "Страница Помощь" do
    before { visit help_path }

  	it { should have_selector('h1', text: "Помощь") }
  	it { should have_selector('title', text: full_title('Помощь')) }
  end

  describe "Страница О нас" do
    before { visit about_path }

  	it { should have_selector('h1', text: "О нас") }
  	it { should have_selector('title', text: full_title('О нас')) }
	end

	describe "Страница Контакты" do
    before { visit contact_path }

  	it { should have_selector('h1', text: "Контакты") }
   	it { should have_selector('title', text: full_title('Контакты')) }
	end
end
