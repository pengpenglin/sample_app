class Micropost < ActiveRecord::Base

  belongs_to :user
  default_scope :order => "microposts.created_at DESC"

  # Since we didn't allow user id to be accessible,
  # we couldn't use mass assignment like :user_id => 1
  # to set value to this column.
  #
  # Instead of set user id directly, micropost model
  # get user id from object relationship, which we called
  # "association"
  attr_accessible :content

  validates :user_id, :presence => true
  validates :content, :presence => true, :length => {:maximum => 140}

end
