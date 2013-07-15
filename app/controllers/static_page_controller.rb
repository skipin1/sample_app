# encoding: utf-8

class StaticPageController < ApplicationController
  def home
  	@title = "Главная"
  end

  def help
  	@title = "Помощь"
  end

  def about
  	@title = "О нас"	
  end

  def contact
  	@title = "Контакты"
  end
end
