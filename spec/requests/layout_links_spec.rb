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

  it "should have a sign up page at /signup" do
    get '/signup'
    response.should have_selector('title', :content => "Sign up")
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
  
end
