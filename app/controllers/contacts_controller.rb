#require 'google_driver/google_docs'
require 'my_google_oauth2'

class ContactsController < ApplicationController
  before_action :require_login, :only => :create
  #skip_before_action :require_login, :only => :set_google_drive_token
  
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
=begin
  def set_google_drive_token
    google_doc = GoogleDrive::GoogleDocs.new(
      Rails.application.secrets.google_client_id,
      Rails.application.secrets.google_client_secret,
      Rails.application.secrets.google_client_redirect_uri )
    oauth_client = google_doc.create_google_client
    auth_token = oauth_client.auth_code.get_token(
      params[:code],
      :redirect_uri => Rails.application.secrets.google_client_redirect_uri )
    if auth_token
      session[:google_token_expires_at] = auth_token.expires?.to_s
      session[:google_token] = auth_token.token
    end
    redirect_to session.delete(:return_to)
  end
=end
  private

  def secure_params
    params.require(:contact).permit(:name, :email, :content).merge(token: session[:google_token])
  end

  def require_login
    #session[:return_to] ||= request.url
    #session.delete(:google_token_expires_at)
    #unless session[:google_token_expires_at].present?
    #  google_drive = GoogleDrive::GoogleDocs.new(
    #    Rails.application.secrets.google_client_id,
    #    Rails.application.secrets.google_client_secret,
    #    Rails.application.secrets.google_client_redirect_uri )
    #  auth_url = google_drive.set_google_authorize_url
    #  redirect_to auth_url
    #end
    #session.delete(:google_token_expires_at)
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

