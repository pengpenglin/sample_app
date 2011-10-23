require 'spec_helper'

describe "Microposts" do

  before(:each) do
    @user = Factory(:user)
    visit signin_path
    fill_in :email,    :with => @user.email
    fill_in :password, :with => @user.password
    click_button
  end

  describe "Creation" do

    describe "Failure" do
      it "Should not create a micropost" do
        lambda do
          visit root_path
          fill_in :micropost_content, :with => ''
          click_button
          response.should render_template('pages/home')
          response.should have_selector("div#error_explanation")
        end.should_not change(Micropost, :count)
      end
    end

    describe "Success" do
      it "Should create a micropost" do
        content = "This is a integration test message"
        lambda do
          visit root_path
          fill_in :micropost_content, :with => content
          click_button
          response.should have_selector("span.content", :content => content)
        end.should change(Micropost, :count).by(1)
      end
    end

  end

  describe "Pagination" do
    describe "less than 30 microposts" do
      it "Should not paginate microposts" do
        visit root_path
        response.should_not have_selector("div.pagination")
      end
    end

    describe "More than 30 microposts" do
      before(:each) do
        50.times do |n|
          Factory(:micropost, :user => @user)
        end
      end

      it "should paginate microposts" do
        visit root_path
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a.next_page", :content => "Next")
        click_link "Next"
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Next")
        response.should have_selector("a.previous_page", :content => "Previous")
      end
    end
  end

  describe "Side bar" do

    it "Should not have any existing micropost"do
      visit root_path
      response.should have_selector("span.microposts", :content => "0")
    end

    it "Should have 1 micropost" do
      visit root_path
      fill_in :micropost_content, :with => "the first micropost"
      click_button
      response.should have_selector("span.microposts", :content => "1 micropost")
    end

    it "Should have 2 microposts" do
      visit root_path
      fill_in :micropost_content, :with => "the first micropost"
      click_button
      fill_in :micropost_content, :with => "the second micropost"
      click_button
      response.should have_selector("span.microposts", :content => "2 microposts")
        
    end

  end

end
