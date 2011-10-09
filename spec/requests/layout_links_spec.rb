require 'spec_helper'

describe "LayoutLinks" do

  # Remember that it..do is the really function that works for Rspec
  # Defind..end is only a chracteristic description for BDD test
  it "should have a home page at '/' " do
    get '/'
    response.should have_selector('title', :content => "Home")
  end
    
  it  "should have a contact page at '/contact'" do
    get '/contact'
    response.should have_selector('title', :content => "Contact")
  end
  
  it "should have a about page at '/about' " do
    get '/about'
    response.should have_selector('title', :content => "About")
  end

  it "should have a help page at '/help' " do
    get '/help'
    response.should have_selector('title', :content => "Help")
  end

  it "should have a sign up page at /signin" do
    get '/signin'
    response.should have_selector('title', :content => "Sign in")
  end

  it "should have the right link on the layout" do
    visit root_path

    click_link "About"
    response.should have_selector("title", :content => "About")
    
    click_link "Help"
    response.should have_selector("title", :content => "Help")

    click_link "Contact"
    response.should have_selector("title", :content => "Contact")

    click_link "Home"
    response.should have_selector("title", :content => "Home")

    # click_link method will hit the hyperlink with given value,
    # which displayed on the page as the part of the output. That
    # means it will try to find the hyperlink with text or title
    # equals to the given name.
    #
    # Note that click_link method is case insenstive, you can use
    # "About" or "about" whenever you like
    #
    # Likes has_selector method, click_link mehtod use regular exp-
    # ression to find link, it should be treat as same for "Sign up
    # now" and "Sign up now!", but it would be treate as different
    # for "sign up now!" and "sign up now !" or "Signup now"
    #
    # Also note that click_link method DOSEN'T support named routes,
    # you COULDN'T use about_path as the parameter, this is different
    # from visit method
    
    # click_link "signup"         # This test will fail due to "not exiting hyperlink"
    # clcik_link "Sing up now !"  # This test will fail also due to regular expression match
    # click_link "Sign up now"    # This test will be successful
    # click_link "sign up NOW"    # This test will be successful
    # click_link "Sign up NOW!"   # This test will be successful
    click_link "Sign up now!"    # This test should fail
    response.should have_selector("title", :content => "Sign up")

  end

  describe "When not sign in" do
    it "Should have a sign in link" do
      visit root_path
      response.should have_selector("a", :href => signin_path, :content => "Sign in")
    end
  end

  describe "When sign in" do
   before(:each) do
     @user = Factory(:user)
     visit signin_path
     fill_in :email,    :with => @user.email
     fill_in :password, :with => @user.password
     click_button
   end

    it "Should have a sign out link" do
      visit root_path
      response.should have_selector("a", :href => signout_path, :content => "Sign out")
    end

    it "should have a user profile link" do
      visit root_path
      response.should have_selector("a", :href => user_path(@user), :content => "Profile")
    end
  end
  
end
