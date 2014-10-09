require 'google_drive/google_docs'

class ContactsController < ApplicationController
  before_action :require_login
  skip_before_action :require_login, :only => :set_google_drive_token
  
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(secure_params)
    if @contact.valid?
      @contact.update_spreadsheet
      # TODO send message
      flash[:notice] = "Message sent from #{@contact.name}."
      redirect_to root_path
    else
      render :new
    end
  end

  def set_google_drive_token
    google_doc = GoogleDrive::GoogleDocs.new(
      Rails.application.secrets.google_client_id,
      Rails.application.secrets.google_client_secret,
      Rails.application.secrets.google_client_redirect_uri )
    oauth_client = google_doc.create_google_client
    auth_token = oauth_client.auth_code.get_token(
      params[:code],
      :redirect_uri => Rails.application.secrets.google_client_redirect_uri )
    session[:google_token] = auth_token.token if auth_token
    redirect_to session.delete(:return_to)
  end

  private

  def secure_params
    params.require(:contact).permit(:name, :email, :content).merge(token: session[:google_token])
  end

  def require_login
    session[:return_to] ||= request.url
    unless session[:google_token].present?
      google_drive = GoogleDrive::GoogleDocs.new(
        Rails.application.secrets.google_client_id,
        Rails.application.secrets.google_client_secret,
        Rails.application.secrets.google_client_redirect_uri )
      auth_url = google_drive.set_google_authorize_url
      redirect_to auth_url
    end
  end

end

