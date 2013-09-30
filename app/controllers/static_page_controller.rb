# encoding: utf-8

class StaticPageController < ApplicationController
  def home
  	@title = "Главная"
    if signed_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: 10)
    end
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
