require 'spec_helper'

describe RelationshipsController do

  describe "assess control" do
    it "should require sign in for create" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should require sign in for destory" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end

  describe "Post 'create'" do
    
    before(:each) do
      @user = test_sign_in(Factory(:user))
      @followed = Factory(:user, :email => Factory.next(:email))      
    end

    it "should create a relationship" do
      lambda do
        post :create, :relationship => {:followed_id => @followed}
        response.should be_redirect        
      end.should change(Relationship, :count).by(1)
    end

    it "Should create a relationship with Ajax" do
      lambda do
        xhr :post, :create, :relationship => {:followed_id => @followed}
      end.should change(Relationship, :count).by(1)
    end

  end

  describe "Delete 'destory'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
      @followed = Factory(:user, :email => Factory.next(:email))
      @user.follow!(@followed)
      @relationship = @user.relationships.find_by_followed_id(@followed)
    end

    it "should destroy the relationship" do
      lambda do
        delete :destroy, :id => @relationship
        response.should be_redirect
      end.should change(Relationship, :count).by(-1)
    end

    it "should destroy the relationship with Ajax" do
      lambda do
        xhr :delete, :destroy, :id => @relationship
      end.should change(Relationship, :count).by(-1)
    end

  end

end
