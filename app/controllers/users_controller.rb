# encoding: utf-8

class UsersController < ApplicationController
  def new
  	@title = "Регистрация"
  	@user = User.new
  end

  def create
  	@user = User.new(params[:user])  	
  	if @user.save
      flash[:success] = "Добро пожаловать, #{@user.name}"
      redirect_to @user
  	else
  		render 'new'
  	end
  end

  def show
  	@user = User.find(params[:id])
  	@title = "Личная страница #{@user.name}"  	
  end
end
