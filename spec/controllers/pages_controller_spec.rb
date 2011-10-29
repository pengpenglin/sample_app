require 'spec_helper'

describe PagesController do

  render_views

  before (:each) do
   @base_title = "Ruby on Rails Tutorial Sample App | "
  end

  describe "GET 'home'" do

    describe "when not signed in" do
      it "should be successful" do
        get 'home'
        response.should be_success
      end

      it "should have right title here" do
        get 'home'
        response.should have_selector("title", :content => @base_title + "Home")
      end
    end

    describe "when signed in" do
      
      before(:each) do        
        @user = test_sign_in(Factory(:user))
        @follower = Factory(:user, :email => Factory.next(:email))
        @follower.follow!(@user)
      end

      it "Should have the right following/follwer count" do
        get :home
        response.should have_selector("a", :href => following_user_path(@user), :content => '0 following')
        response.should have_selector("a", :href => followers_user_path(@user), :content => '1 follower')
      end

    end

  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end

    it "should have right title here" do
      get 'contact'
      response.should have_selector("title", :content => @base_title + "Contact")
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end

    it "should have right title here" do
      get 'about'
      response.should have_selector("title", :content => @base_title + "About")
    end 
  end  

  describe "GET 'help'" do
    it "should be successful" do
      get 'help'
      response.should be_success
    end

    it "should have right title here" do
      get 'help'
      response.should have_selector("title", :content => @base_title + "Help")
    end
  end
end
