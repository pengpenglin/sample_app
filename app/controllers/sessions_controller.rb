class SessionsController < ApplicationController

  def new
    @title = "Sign in"
  end

  def create    
    # Here we call the UsersController's class method
    # authenticate to varify the user. This method will
    # find an user with given email address or return nil
    # if no mattchgg
    #
    # Remember that we SHOULD NOT create an User instance
    # directly in SessionsController due to the design prin-
    # ciple of loose coupling
    user = User.authenticate(params[:session][:email],
                              params[:session][:password])
    if user.nil?
      # Since we don't have a Session model, we can't display
      # error messages like this: @sesssion.errors.full_message.
      # So we use Rails flash instead. 
      #
      # The application.html.erb will display all the flash
      # messages in a loop: 
      #
      #  flash.each do |key, value|
      #   # Some expressions
      #  end
      #
      @title = "Sign in"
      flash.now[:error] = "Invalid email/password conbination"
      render 'new'
    else
      # After passing user authentication, we invoke sign_in
      # method to persist the cookie to browser, then we can
      # get back next time if we choose "Remember me".
      #
      # Besides that, since this action will be performaned
      # every time the user signin with email and password,
      # so this cookie will be updated accordinally
      sign_in user
      redirect_back_or user
    end
  end

  def destroy    
    sign_out
    redirect_to root_path
  end

end
