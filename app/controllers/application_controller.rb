class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  #forzar cierre de sesion para prevenir ataques CSRF
  def handle_unverified_request
    sign_out
    super
  end
end
