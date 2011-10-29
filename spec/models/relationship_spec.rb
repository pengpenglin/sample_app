require 'spec_helper'

describe Relationship do

  before(:each) do
    @follower = Factory(:user)
    @followed = Factory(:user, :email => Factory.next(:email))
    @relationship = @follower.relationships.build(:followed_id => @followed.id)
  end

  it "Should create a relationship given valid attributes" do
    @relationship.save!
  end

  describe "follow method" do

    before(:each) do
      @relationship.save!
    end

    it "Should have a followed attribute" do
      @relationship.should respond_to(:followed_id)
    end

    it "Should have the right followed" do
      @relationship.followed.should == @followed
    end

    it "Should have a follower attribute" do
      @relationship.should respond_to(:follower_id)
    end

    it "Should have the right follower" do
      @relationship.follower.should == @follower
    end

  end

  describe "validtions" do

    it "should require a followed id" do
      @relationship.followed = nil
      @relationship.should_not be_valid
    end

    it "Should require a follower id" do
      @relationship.follower = nil
      @relationship.should_not be_valid
    end
    
  end

end
