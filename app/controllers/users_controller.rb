# encoding: utf-8

class UsersController < ApplicationController

  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy

  def index
    @title = "Пользователи"
    @users = User.paginate(page: params[:page], per_page: 30)
  end

  def new
  	@title = "Регистрация"
  	@user = User.new
  end

  def create
  	@user = User.new(params[:user])  	
  	if @user.save
      sign_in @user
      flash[:success] = "Добро пожаловать, #{@user.name}"
      redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
    @title = "Редактирование пользователя"    
    #@user = User.find(params[:id])    
  end

  def update
    #@user = User.find(params[:id])    
    if @user.update_attributes(params[:user])
      flash[:success]= "Выша информация обновлена"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def show
  	@user = User.find(params[:id])
  	@title = "Пользователь #{@user.name}"  	
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Пользователь успешно удален!"
    redirect_to users_path
  end

  private

    def signed_in_user
      unless signed_in?
        store_location  # remember the request URL
        redirect_to signin_url, notice: "Пожалуйста авторизуйтесь"
      end      
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to edit_user_path(current_user), notice: "Попытка редактирования чужого профиля. Редактируйте свой." unless current_user?(@user)
    end

    def admin_user
      redirect_to root_path unless current_user.admin?      
    end
end
