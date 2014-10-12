class UserMailer < ActionMailer::Base
  default from: "do-not-reply@example.com"

  def contact_email(contact, token)
    @contact = contact
    settings = {
      account: Rails.application.secrets.email_provider_username,
      oauth2_token: token
    }
    mail(to: Rails.application.secrets.owner_email,
         from: @contact.email,
         :subject => "Website Contact",
         delivery_method_options: settings)
  end
end
