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

require "digest"

class User < ActiveRecord::Base

  # attr_accessor method is used to create an attribute
  # which dosen't exist in DB but required in memory/model.
  # Here :password symbol is a mapping of form field
  #
  # attr_accessible method define which set of attributes
  # can be access by Rails app. Think it as a public variable
  # or method
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation

  # Note that here we use microposts instead of micropost
  # to indicate that one-to-many association
  has_many :microposts, :dependent => :destroy

  # An user can have many relationship, one of them is "following".
  # The :foreign_key option means that: Rails can use the follower_id
  # as the foreign key to find user. Since in following relationship,
  # user is the "follower" to another user, so the follower_id equals
  # to current user id.
  #
  # The SQL issued by Rails will be like:
  #
  #  SELECT relationships.followed_id
  #         from user a,relationship b
  #        where a.id = b.follower_id
  #          and a.id = ?
  has_many :relationships, :foreign_key => 'follower_id', :dependent => :destroy


  # The reverse relationship is "follower". User is being followed by
  # others. Rails will issue a SQL like this:
  #
  #  Select relationships.follower_id
  #    from user a, relationship b
  #   where a.id = b.followed_id
  #     and a.id = ?
  #
  # Since reverse relationship still keep in table relationships, we
  # just need to use :class_name to tell Rails explicitly
       

  has_many :reverse_relationships, :foreign_key => "followed_id",
           :class_name => "Relationship", 
           :dependent => :destroy 

  # Through 'relationships' we can say that: user has many following,
  # note that here we SHOULD NOT defind the cascade for dependent.
  # If an user was destroyed, the relationship should be destroyed 
  # instead of his following or followers
  has_many :following, :through => :relationships, :source => :followed

  # As the same with following relationship, user can also find many
  # followers through reverse_relationship 
  has_many :followers, :through => :reverse_relationships, :source => :follower

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # Validations for name and email attributes
  validates :name,  :presence => true,
                    :length => {:maximum => 50}

  validates :email, :presence => true,
                    :format => {:with => email_regex},
                    :uniqueness => {:case_sensitive => false}

  # Automatically create the virtual column "password_confirmation"
  validates :password, :presence => true,
                       :confirmation => true,
                       :length => {:within => 6..40 }

  # Regist a callback method encrypt_password to be called
  before_save :encrypt_password

  # Define a class method to do authentication
  def self.authenticate(email,submitted_password)
    user = User.find_by_email(email)
    #return nil if user.nil?
    #return user if user.has_password?(submitted_password)
    user && user.has_password?(submitted_password) ? user : nil
  end

  def self.authenticate_with_salt(id, salt)
    user = User.find_by_id(id)
    (user && user.salt == salt)? user : nil
  end

  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    # Compare the encrypted_password with the encrypted version of
    # submitted password
    encrypted_password == encrypt(submitted_password)
  end

  # Return the microposts posted by current user
  def feed
    # Micropost.where("user_id = ?", id)
    Micropost.from_users_followed_by(self)
  end

  # Find whether the given user is followed by current user
  def following?(followed)
    relationships.find_by_followed_id(followed)
  end

  # Follow an user
  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end

  # Unfollow user
  def unfollow!(followed)
    relationships.find_by_followed_id(followed.id).destroy
  end

# ----------------------Private method--------------------------------

  private

    def encrypt_password      
      # Here keyword "self" tells the encrypted_password
      # is an instance varaiable instead of local varaible
      #
      # Rather than use self.password we can omit the keyword
      # and use password instead. This won't make Rails consider
      # it as a local varaible since it placed at the right sitei
      #   
      # self.encrypted_password = encrypt(:password) # same to password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def make_salt
      secure_hash("#{Time.now.utc}---#{password}")
    end

    def encrypt(string)
      secure_hash("#{salt}---#{string}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
 
end
