class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_contact_variables, :except => {:admin => :dashboard, :admin => :post, :admin => :bet, :admin => :user, :admin => :category, :admin => :subcategory}

  after_filter :store_location

	# Redirect the user to previous page after login, sign-up, etc
	def store_location
	  # store last url - this is needed for post-login redirect to whatever the user last visited.
	  if !devise_controller? && !request.xhr? # don't store ajax calls
	    session[:previous_url] = request.fullpath 
	  end
	end

	def after_sign_up_path_for(resource)
	  root_path
	end

	def after_sign_in_path_for(resource)
	  session[:previous_url] || root_path
	end

	def after_update_path_for(resource)
  	session[:previous_url] || root_path
	end

	def after_sign_out_path_for(resource)
  	root_path
	end

	def set_contact_variables
		@contact = Contact.new(params[:contact])
	end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:sign_up) << :terms
    devise_parameter_sanitizer.for(:account_update) << :name
  end
end
