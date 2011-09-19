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

  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    # Compare the encrypted_password with the encrypted version of
    # submitted password
    self.encrypted_password == encrypt(submitted_password)
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
