require 'spec_helper'

describe UsersController do

  render_views

  #---------------------Test for 'new' action ------------------------------

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "should have the right title" do
      get 'new'
      response.should have_selector('title', :content=>"Sign up")
    end    
  end

  #--------------------Test for 'show' action------------------------------

  describe "GET 'show'" do
    before(:each) do
      @user = Factory(:user)
    end

    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end

    it "should find the righ user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end


    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end

    it "should include the user name" do
      get :show, :id => @user
      response.should have_selector("h1",:content =>  @user.name)
    end

    it "should have the user image" do
      get :show, :id => @user
      response.should have_selector("h1>img",:class => "gravatar")
    end

  end

  ###############################################################
  #
  # What dose a 'create' action do in this test:
  #
  #  1. Browser issues a request /users/create to Rails server
  #  2. Request mapped to UsersController and 'create' action
  #  3. Controller extracts parameters (a hash) by symbol
  #  4. Instantite a User model by hash paramters
  #  5. Validate user before save
  #  6. Save and return the result
  #  7. If test fail then render the 'new' page (/users/new)
  #  8. The page invoke partial to render error message
  #
  ##############################################################
  describe "Post 'create'" do

    #------------------------Test for create action------------------------

    describe "Failure" do

      before(:each) do
        @attr = {:name => "", :email => "", :password => "", :password_confirmation => ""}
      end

      it "should not create user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign up")
      end

      it "should have render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end    

    end

    describe "success" do

      before(:each) do
        @attr = {:name => "pengpenglin", :email => "paullin81@gmail.com",
                 :password => "foobar", :password_confirmation => "foobar"}
      end

      it "should create a new user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to user home page" do
        post :create, :user => @attr
        # assign(:user) => @user
        # user_path(@user) => users/user.id
        # redirect_to(/users/id) => HTTP 302 redirect
        response.should redirect_to(user_path(assigns(:user)))
      end

      it "should have a welcome message" do
        post :create, :user => @attr
        # Here we use the regular expresssion to identify the
        # output contains the string we expected
        flash[:success].should =~ /welcome to the sample app/i
      end

    end

  end
  
end
