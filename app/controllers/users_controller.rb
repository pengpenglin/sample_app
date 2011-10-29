class UsersController < ApplicationController

  # For all signed-in required page, we should apply authenticate filter
  # For edit and update user profile, we should apply for user self only (even admin)
  # For delete user, we should only apply for admin user
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user,   :only => [:edit, :update]
  before_filter :admin_user,     :only => [:destroy]
  before_filter :signed_in_user, :only => [:new, :create]

  def index
    @users = User.paginate(:page => params[:page])
    @title = "All users"
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
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

  def edit
    #@user = User.find(params[:id]) # No need anymore since correct_user method
    @title = "Edit user"
  end

  def update
    #@user = User.find(params[:id]) # No need anymore since correct_user method
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end    
  end

  def destroy
    @user = User.find(params[:id])
    if current_user?(@user)
      redirect_to root_path
    else
      @user.destroy
      flash[:success] = "User destroyed"
      redirect_to users_path
    end
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    # Note that 'show_follow' is not a partial, but a erb page
    # that means no "_" prefix before "show"
    #
    # If we use render in view, that means it's a partial hence
    # a "_" should insert before partial name
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end

  #----------------------Private method-------------------------
  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end
    
    def admin_user
      redirect_to root_path unless current_user.admin?
    end

    def signed_in_user
      redirect_to root_path if signed_in?
    end

end
