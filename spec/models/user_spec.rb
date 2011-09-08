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
    @attr = {:name => "Example user", :email => "user@example.com"}
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

end
