# encoding: utf-8

class SessionsController < ApplicationController
	
	#before_filter :registr_user, only: [:new, :create]

	def new
		@title = "Вход в систему"
	end

	def create
		@title = "Вход в систему"
		user = User.find_by_email(params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			sign_in user
			redirect_back_or user
		else
			flash.now[:error] = 'Не верная комбинация логин/пароль'
      render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_url, notice: "Вы успешно вышли. До свидания."
	end

end
