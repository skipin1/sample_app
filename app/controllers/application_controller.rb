# encoding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery

  include SessionsHelper

  # Force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out
    super
  end

  private

		def registr_user
			redirect_to root_path, notice: "Вы уже зарегистрированы." if signed_in?
		end
end
