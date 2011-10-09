class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def new
    @user = User.new
    @title = "Sign up"
  end

  def create
    @user = User.new(params[:user])
    if @user.save 
      sign_in @user
      flash[:success] = "Welcome to the Sample App"
      # redirect_to user_path(@user) also works
      # Note that here we can't use render @user
      # Rails will treat it as /users/user hence
      # no routes match
      redirect_to @user 
    else
      @title = "Sign up"
      @user.password = nil
      @user.password_confirmation = nil
      # Here we render the 'new' page, which didn't hit the new
      # action in UsersController. So Rails won't create a new
      # model again. In new.html.erb, we saw form_for access the
      # user object with @user, that is the one Rails created before,
      # so any existing attributes in this model will be displayed
      render 'new'
    end
  end

end
