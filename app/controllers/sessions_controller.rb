class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      #iniciar sesion y redirigir a la pagina del usuario
      sign_in user
      redirect_to user
    else
      # crear un mensaje de error y re-renderizar la pagina de inicio de sesion
      flash.now[:error] = 'Combinacion de email/password incorrecta'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
