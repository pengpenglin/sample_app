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
      flash[:success] = "Welcome to the Sample App"
      redirect_to @user # redirect_to user_path(@user) also works
    else
      @title = "Sign up"
      # Here we redirect the page to 'new', which didn't hit the
      # new action in UsersController. So Rails won't create a new
      # model. In new.html.erb, we saw form_for access the user
      # object with @user, that is the one Rails created before,
      # so any existing attributes in this model will be displayed
      render 'new'
    end
  end

end
