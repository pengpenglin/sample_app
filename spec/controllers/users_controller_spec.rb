require 'spec_helper'

describe UsersController do

  render_views

  #---------------------Test for 'index' action----------------------------
  describe "GET 'index'" do

   describe "For non-sign-in user" do
     it "Should deny access" do
       get :index
       response.should redirect_to(signin_path)
       flash[:notice].should =~ /sign in/i
     end
   end

   describe "For sign in user" do
    
     before(:each) do
       # test_sign_in --> sign_in --> self.current_user = user
       @user = test_sign_in(Factory(:user))
       second = Factory(:user, :email => "second@163.com")
       third  = Factory(:user, :email => "third@163.com")
       @users = [@user, second, third]

       30.times do
         @users << Factory(:user, :email => Factory.next(:email))
       end
     end

     it "Should be success" do
       get :index
       response.should be_success
     end

     it "Should have the right title" do
       get :index
       response.should have_selector("title", :content => "All users")
     end

     it "Should list all users" do
       get :index
       @users.each do |user|
         response.should have_selector("li", :content => user.name)
       end
     end

     it "Should not have delete link for normal user" do
       get :index
       @users.each do |user|
         response.should_not have_selector("a", :herf => user_path(user), :content => "Delete")
       end
     end

     it "Should have delete link for admin user" do
       admin_user = Factory(:user,:email => Factory.next(:email),:admin => true)
       test_sign_in(admin_user)
       get :index
       response.should have_selector("a", :href => "/users/2", :content => "Delete")       
     end

     it "Should not display delete link for user itself" do
       admin_user = Factory(:user, :email => Factory.next(:email), :admin => true)
       test_sign_in(admin_user)
       get :index
       response.should_not have_selector("a", :href => user_path(admin_user), :content => "Delete")
     end

     it "Should list element for each user" do
       get :index
       @users[0..2].each do |user|
         response.should have_selector("li", :content => user.name)
       end
     end

     it "Should paginate users" do
       get :index
       response.should have_selector("div.pagination")
       response.should have_selector("span.disabled", :content => "Previous")
       response.should have_selector("a", :href => "/users?page=2", :content => "2")
       response.should have_selector("a", :href => "/users?page=2", :content => "Next")
     end

   end

  end

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

    it "should have the name field" do
      get :new
      response.should have_selector("input [name='user[name]'] [type='text']")
    end

    it "should have the email field" do
      get :new
      response.should have_selector("input [name='user[email]'] [type='text']")
    end

    it "should have the password field" do
      get :new
      response.should have_selector("input [name='user[password]'] [type='password']")
    end

    it "should have the password confirmation field" do
      get :new
      response.should have_selector("input [name='user[password_confirmation]'] [type='password']")
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

    it "Should have the user microposts content" do
      mp1 = Factory(:micropost, :user => @user, :content => "post 1")
      mp2 = Factory(:micropost, :user => @user, :content => "post 2")
      get :show, :id => @user
      response.should have_selector("span.content", :content => mp1.content)
      response.should have_selector("span.content", :content => mp2.content)
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

      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end

    end

  end

  #----------------------Test for 'edit' action----------------------

  describe "GET 'edit'" do
    
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    it "Should be success" do
      get :edit, :id => @user
      response.should be_success
    end

    it "Should have the right title" do
      get :edit, :id => @user
      response.should have_selector("title", :content => "Edit user")
    end

    it "Should change the Gravatar" do
      get :edit, :id => @user
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector("a", :href => gravatar_url, :content => "Change")
    end
  end
  
  #------------------Test for 'update' action---------------------
  describe do

    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    describe "Failure" do
      before(:each) do
        @attr = {:name => "", :email => "",
                 :passowrd => "", :password_confirmation => ""}
      end

      it "Should render the 'edit' page" do
        put :update, :id => @user, :user =>@attr
        response.should render_template('edit')
      end

      it "Should have the right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector("title", :content => "Edit user")
      end
    end

    describe "Success" do
      before(:each) do
        @attr = {:name => "Pengpenglin", :email => "paullin81@gmail.com",
                 :password => "123456", :password_confirmation => "123456"}
      end

      it "Should change the user's attributes" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.name.should == @attr[:name]
        @user.email.should == @attr[:email]
      end

      it "Should redirect to user show page" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(user_path(@user))
      end

      it "Should have the flash message" do
        put :update, :id => @user, :user => @attr
        flash[:success] =~ /updated/
      end

    end

  end

  #----------------------Test for secuirty signin function--------------------
  describe "Authentication of 'edit' & 'update' page" do
    
    before(:each) do
      @user = Factory(:user)
    end

    describe "For non-signin users" do
      it "Should deny access of 'edit' page" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end

      it "Should deny access of 'update' page" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(signin_path)
      end
    end

    describe "For signed in users" do
    
      before(:each) do
        wrong_user = Factory(:user, :email => "wrongmail@163.com")
        test_sign_in(wrong_user)
      end
      
      it "Should require user to match 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end

      it "Should require user to match 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end
    end
  end
  
  #----------------------Test for delete function--------------------
  describe "Delete 'destroy'" do

    before(:each) do
      @user = Factory(:user)
    end

    describe "As non-sign-in user"do
      it "Should deny access " do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end
    end

    describe "As non-administrator user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end
    end

    describe "As administrator user" do
      before(:each) do
        @admin = Factory(:user, :email => Factory.next(:email), :admin => true)
        test_sign_in(@admin)
      end

      it "Should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end

      it "Should not destroy admin user self" do
        lambda do
          delete :destroy, :id => @admin          
        end.should_not change(User, :count)
      end

      it "Should redirect to users page" do
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end
      
    end

  end

  #-----------------------Test for follow pages---------------------------
  describe "Follow message" do

    describe "When not sign in" do
      it "Should protect following page" do
        get :following, :id => 1
        response.should redirect_to(signin_path)
      end

      it "Should protect follower page" do
        get :followers, :id => 1
        response.should redirect_to(signin_path)
      end
    end

    describe "When signed in" do
      before(:each) do
        @user = test_sign_in(Factory(:user))
        @other_user = Factory(:user, :email => Factory.next(:email))
        @user.follow!(@other_user)
      end

      it "Should show user following" do
        get :following, :id => @user
        response.should have_selector("a", :href => user_path(@other_user), 
                                           :content => @other_user.name)
      end

      it "Should show user followers" do
        get :followers, :id => @other_user
        response.should have_selector("a", :href => user_path(@user),
                                           :content => @user.name)
      end
    end

  end

end
