class ContactsController < ApplicationController

  # Pay Attention here!  The 'new' method below is an instance
  # method and does not affect the 'new' class method used to
  # instantiate this class.
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(secure_params)
    if @contact.valid?
      # TODO save data
      # TODO send message
      flash[:notice] = "Message sent form #{@contact.name}."
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def secure_params
    params.require(:contact).permit(:name, :email, :content)
  end

end

