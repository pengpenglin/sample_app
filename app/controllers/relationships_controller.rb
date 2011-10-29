class RelationshipsController < ApplicationController
  before_filter :authenticate

  def create
    # params[:relationship] returns the HashMap that 
    # contains key :followed_id
    # Refer to views/users/_follow.html.erb
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end

  def destroy
    # params[:id] return the relationship id
    # Refer to views/users/_unfollow.html.erb
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end

end
