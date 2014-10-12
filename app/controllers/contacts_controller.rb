require 'my_google_oauth2'

class ContactsController < ApplicationController
  before_action :require_login, :only => :create
  
  def new
    @contact = Contact.new
    #session[:my_contact] = @contact
  end

  def create
    @contact = Contact.new(secure_params)
    if @contact.valid?
      @contact.update_spreadsheet
      UserMailer.contact_email(@contact, session[:google_token]).deliver
      flash[:notice] = "Message sent from #{@contact.name}."
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def secure_params
    params.require(:contact).permit(:name, :email, :content).merge(token: session[:google_token])
  end

  def require_login
      client = MyGoogleOauth2::Client.new(
      Rails.application.secrets.google_client_id,
      Rails.application.secrets.google_client_secret,
      Rails.application.secrets.google_refresh_token)
    if session[:google_token].present?
      unless client.access_token_valid?(session[:google_token])
        session[:google_token] = client.exchange_refresh_token
      end
    else
      session[:google_token] = client.exchange_refresh_token
    end
  end

end

