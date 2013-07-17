# encoding: utf-8

require 'spec_helper'

describe "UserPages" do
  subject { page }

  describe "страница регистрации" do
  	before { visit signup_path }

    it { should have_selector('h1', text: "Регистрация")}
    it { should have_selector('title', text: full_title('Регистрация'))}
  end
end