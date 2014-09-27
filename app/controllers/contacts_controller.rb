class ContactsController < ApplicationController
  def new
    @contact = Contact.new
    @title = 'Contact Us'
  end

  def create
    @contact = Contact.new(params[:contact])
    @contact.request = request
    if @contact.deliver
      flash.now[:notice] = 'Thank you for your message. We will contact you soon!'
    else
      flash.now[:error] = 'Oops - something went wrong. Please try again.'
      render :new
    end
  end
end