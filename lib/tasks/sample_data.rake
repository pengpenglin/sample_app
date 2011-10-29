require 'faker'

namespace :db do
  desc "Fill db with sample data"
  task :populate => "environment" do
    Rake::Task['db:reset'].invoke
    make_users
    make_microposts
    make_relationships
  end
end

# Define sample data for User model
def make_users
  admin = User.create!(:name => "Paul",
                       :email => "pengpenglin@163.com",
                       :password => "foobar",
                       :password_confirmation => "foobar")
  admin.toggle!(:admin) # Since attr_accessible in User.rb, this filed is not visible
  99.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@163.com"
    User.create!(:name => name, :email => email,
                 :password => "password",
                 :password_confirmation => "password")
  end
end

# Define sample data for Micropost model
def make_microposts
  User.all(:limit => 6).each do |user|
    50.times do
      user.microposts.create!(:content => Faker::Lorem.sentence(5))
    end
  end
end

# Define relationships between user and others
def make_relationships
  users = User.all
  user = users.first
  following = users[1..50]
  followers = users[3..40]
  following.each {|followed| user.follow!(followed)}
  followers.each {|follower| follower.follow!(user)}
end
