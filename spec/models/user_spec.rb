# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe User do

  before(:each) do
    @attr = {:name => "Example user",
             :email => "user@example.com",
             :password => "foobar",
             :password_confirmation => "foobar"}
  end

  it "should create a new instance with given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    # no_name_user = User.create(@attr.merge(:name => ""))  # We can use create method
    # no_name_user = User.create!(@attr.merge(:name => "")) # We CAN'T use create method
    #
    # Pls note that create! method will automatically save record
    # to DB and throw an exception of once fail to validate anything.
    # That means it will cause test to be fail when try to exectue
    # create! action instead of assert statement
    #
    # If we use create method, only "false" will be returned by this
    # method if fail to validation. So it equals to new at this case
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should require a email address" do
    no_email_user = User.create(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "should reject a too long name" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should accept valid email address" do
    addresses = %w[foo@bar.com 123@bar.org 163@foo.com _yy@123.net]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid      
    end
  end

  it "should reject unvalid email address" do
    addresses = %w[foo@bar 123@bar _@@foo.cn]
    addresses.each do |address|
      unvalid_email_user = User.new(@attr.merge(:email => address))
      unvalid_email_user.should_not be_valid
    end
  end

  it "should reject dumplicated email address" do
    User.create!(@attr)
    user_email_address = @attr[:email].upcase
    user_with_duplicate_email = User.new(@attr.merge(:email => user_email_address))
    user_with_duplicate_email.should_not be_valid
  end
  
  describe "Password validation" do
    
    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
    end

    it "should require password confirmation" do
      User.new(@attr.merge(:password_confirmation => "bob")).should_not be_valid
    end

    it "should reject a too short password" do
      short = "a" * 3
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

    it "should reject a too long password" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end

  end

  describe "Password encryption" do
   
    before(:each) do
      @user = User.create!(@attr)      
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    it "should be true if the password matches" do
      @user.has_password?(@attr[:password]).should be_true
    end

    it "should be false if the password dosen't match" do
      @user.has_password?("invalid").should be_false
    end

  end

  describe "Authenticate method"do

    it "should return nil on email/password not match" do
      wrong_password_user = User.authenticate(@attr[:email], "wrong")
      wrong_password_user.should be_nil
    end

    it "should return nil on nonexistent user" do
      non_existent_user = User.authenticate("newuser", @attr[:password])
      non_existent_user.should be_nil
    end

    it "should return user on email/password matching" do
      matching_user = User.authenticate(@attr[:email], @attr[:password])
      matching_user.should == @user
    end
  end

  describe "Admin attribute" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "Should respond to admin" do
      @user.should respond_to("admin")
    end

    it "Should not be a admin user by default" do
      @user.should_not be_admin
    end

    it "Should be convertible to admin user" do
      @user.toggle("admin")
      @user.should be_admin
    end
  end

  describe "Microposts association" do

    before(:each) do
      @user = User.create(@attr)
      @mp1  = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
      @mp2  = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
    end

    it "Should have a microposts attributes" do
      @user.should respond_to(:microposts)
    end

    it "Should have the mircropost" do
      @user.microposts.should == [@mp2, @mp1]
    end

    it "Should destroy associated microposts" do
      @user.destroy
      [@mp1,@mp2].each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end

    describe "Status feed" do

      it "Should have a feed" do
        @user.should respond_to(:feed)
      end

      it "Should include the user's micorpost" do
        @user.feed.include?(@mp1).should be_true
        @user.feed.include?(@mp2).should be_true
      end

      it "Should not include different user's micropost" do
        mp3 = Factory(:micropost, :user => Factory(:user, :email => Factory.next(:email)))
        @user.feed.include?(mp3).should be_false 
      end

    end

  end

end
