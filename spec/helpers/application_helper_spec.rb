# encoding: utf-8

require 'spec_helper'

describe ApplicationHelper do

  describe "заголовок" do
    it "должен содержать заголовок страницы" do
      full_title("foo").should =~ /foo/
    end

    it "должен содержать базовый заголовок" do
      full_title("foo").should =~ /^Ruby on Rails Tutorial Sample App/
    end

    it "не должен содержать разделитель, если имя страницы отсутствует" do
      full_title("").should_not =~ /\|/
    end
  end
end