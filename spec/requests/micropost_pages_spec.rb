# encoding: utf-8

require 'spec_helper'

describe "страница Micropost" do
	
	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	before { sign_in user }

	describe "создание сообщения" do
		before { visit root_path }

		describe "с неправильной информацией" do

			it "не должен создать сообщение" do
				expect { click_button "Создать" }.not_to change(Micropost, :count)
			end

			describe "сообщение об ошибке" do
				before { click_button "Создать" }
				it { should have_content('ошибка') }
			end
		end

		describe "с правильной информацией" do

			before { fill_in 'micropost_content', with: "Lorem ipsum" }
			it "должен создать сообщение" do
				expect { click_button "Создать" }.to change(Micropost, :count).by(1)
			end
		end
	end

	describe "удаление сообщения" do
		before { FactoryGirl.create(:micropost, user: user) }

		describe "правильный пользователь" do
			before { visit root_path }

			it "должен удалить микросообщение" do
				expect { click_link "Удалить" }.to change(Micropost, :count).by(-1)
			end
		end
	end
end
