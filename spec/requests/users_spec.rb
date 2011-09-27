require 'spec_helper'

describe "Users" do

  #-------------------Test for signup : both failure/success--------------------
  describe "signup" do
  
    ####################################################
    #
    # With Rspec integration test and lambda block, we can
    # test Rails route(visit), controller (implict), view
    # (form fields), and model (User.count). This is what
    # an integration mean an do for us
    #
    ###################################################
    describe "failure" do
      it "should not create user" do
        lambda do
          visit signup_path
          fill_in "Name",      :with => ""
          fill_in "Email",     :with => ""
          fill_in "Password",  :with => ""
          fill_in "Confirmation", :with => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end

    describe "success" do
      it "should create a new user" do
        lambda do
          visit signup_path
          fill_in :user_name,                  :with => "Bob"
          fill_in :user_email,                 :with => "boblin@163.com"
          fill_in :user_password,               :with => "boblin"
          fill_in :user_password_confirmation, :with => "boblin"
          click_button
          response.should render_template(assigns(:user)) # equals response.should render_template('users/show')
          response.should have_selector("div.flash.success", :content => "Welcome")
        end.should change(User, :count).by(1)
      end
    end
    
  end
end
