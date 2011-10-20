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
  
end
