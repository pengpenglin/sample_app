require 'spec_helper'

describe Micropost do

  before(:each) do
    @user = Factory(:user)
    @attr = { :content => "value for content" }
  end

  it "Should create new instance given value" do
    @user.microposts.create!(@attr)
  end

  describe "Should have right association" do
    before(:each) do
      @micropost = @user.microposts.create!(@attr)
    end

    it "Should have a user attribute" do
      @micropost.should respond_to(:user)
    end

    it "Should have the right associated user" do
      @micropost.user_id.should == @user.id
      @micropost.user.should == @user
    end

    it "should require a user id" do
      micropost = Micropost.new(@attr)
      micropost.should_not be_valid
    end

    it "Should require post content" do
      # build method will set the user_id to user.id automatically
      # while User.new only fill the other attributes
      @user.microposts.build(:content => '').should_not be_valid
    end

    it "Should reject a too long content" do
      @user.microposts.build(:conent => "a" * 141).should_not be_valid
    end
  end

  describe "From_users_followed_by" do
    
    before(:each) do
      @other_user = Factory(:user, :email => Factory.next(:email))
      @third_user = Factory(:user, :email => Factory.next(:email))

      @user_mp  = @user.microposts.create!(:content => "Foo")
      @other_mp = @other_user.microposts.create!(:content => "Bar")
      @third_mp = @third_user.microposts.create!(:content => "Baz")

      @user.follow!(@other_user)
    end

    it "Should have a from_users_followed_by class method" do
      Micropost.should respond_to(:from_users_followed_by)
    end

    it "Should include the followed user's micropost" do
      Micropost.from_users_followed_by(@user).should include(@other_mp)
    end

    it "Should include the user's own micropost" do
      Micropost.from_users_followed_by(@user).should include(@user_mp)
    end

    it "Should not include the unfollowed user's micropst" do
      Micropost.from_users_followed_by(@user).should_not include(@third_mp)
    end

  end

end
