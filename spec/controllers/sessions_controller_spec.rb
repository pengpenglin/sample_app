require 'spec_helper'

describe SessionsController do

  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Sign in")
    end
  end

  describe "PSOT 'create'" do

    describe "Invalid signin" do
      before(:each) do
        @attr = {:email => "pengpenglin@163.com", :password => "invalid"}
      end

      it "should re-render the new page" do
        post :create, :session => @attr
        response.should render_template('new')
      end

      it "should have the right title" do
        post :create, :session => @attr
        response.should have_selector("title", :content => "Sign in")
      end

      it "should have the flash.now message" do
        post :create, :session => @attr
        flash.now[:error].should =~ /invalid/i
      end
    end

    describe "With valid email and password" do
      before(:each) do
        @user = Factory(:user)
        @attr = {:email => @user.email, :password => @user.password}
      end

      it "should sign the user in" do
        post :create, :session => @attr
        # Here we refer to variable and method provided
        # by helper class directly
        controller.current_user.should == @user
        controller.should be_signed_in
      end

      it "should redirect to user profile page" do
        post :create, :session => @attr
        response.should redirect_to(user_path(@user))
      end
    end

  end

  describe "DELETE 'destory'" do
    it "Should sign an user out" do
      test_sign_in(Factory(:user))
      delete :destroy
      controller.should_not be_signed_in
      response.should redirect_to(root_path)
    end
  end

end
