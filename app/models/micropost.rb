class Micropost < ActiveRecord::Base

  belongs_to :user
  default_scope :order => "microposts.created_at DESC"
  scope :from_users_followed_by, lambda {|user| followed_by(user)}

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
  
  private

  def self.followed_by(user)
    # We don't use below comment statement because of the scale
    # performance is not good:
    #
    #   @followed_ids = user.following.map(&:id).join(', ')
    #
    # When user.following was called, all being followed users will
    # be pull out from DB but just return the id that consist the array
    # only. That would be a waste of memery. 
    #
    # We could use "subselect" SQL statement to retrive all the ids in 
    # one time by issue only SQL and pass the user id as parameter

    @followed_ids = %(SELECT followed_id FROM relationships
                       WHERE follower_id = :user_id)
    where("user_id IN (#{@followed_ids}) OR user_id = :user_id", {:user_id => user.id})
  end

end
