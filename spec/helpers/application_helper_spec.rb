# encoding: utf-8

require 'spec_helper'

describe ApplicationHelper do

  describe "full_title" do
    it "должен содержать заголовок страницы" do
      full_title("foo").should =~ /foo/
    end

    it "должен содержать базовый заголовок" do
      full_title("foo").should =~ /^Ruby on Rails Tutorial Sample App/
    end

    it "should not include a bar for the home page" do
      full_title("").should_not =~ /\|/
    end
  end
end