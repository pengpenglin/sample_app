class Relationship < ActiveRecord::Base
  
  # User can only control whom to following
  # but not whom to follow by, so follower_id
  # should not be accessible
  attr_accessible :followed_id

  # A relationship represents an assocaition
  # between a follwer and a followed. That
  # means at both end of this association, 
  # they all refer to an existing user
  #
  # Since Rails will automatically infer the 
  # foreign key by the symbol, the belongs_to
  # will force Rails to detect the primary key
  # whose name is called follower_id or follow
  # -ed_id.
  #
  # Unfortunately we don't have neither a table
  # called follower nor followed,so no follower_id
  # or followed_id exist. Instead, we tell Rails
  # to refer these two forgein key to the User 
  # table and its primary key : user_id
  belongs_to :follower, :class_name => "User"
  belongs_to :followed, :class_name => "User"

  validates :follower_id, :presence => true
  validates :followed_id, :presence => true

end
