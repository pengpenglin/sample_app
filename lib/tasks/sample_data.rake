require 'faker'

# Step 1: Define the namespace
namespace :db do
  desc "Create sample data for testing"
  # Step 2: Define the rake job name :populate
  task :populate => :environment do
    # Step 3: Clean db
    Rake::Task['db:reset'].invoke
    # Step 4: Create first record with administrative privilege
    admin = User.create!(:name => "Paul", :email => "pengpenglin@163.com",
                 :password => "foobar", :password_confirmation => "foobar")
    admin.toggle!(:admin) # Since attr_accessible in User.rb, this filed is not visible
    # Step 5: Create 99 records by faker to simulate users in development db
    99.times do |n|
       name = Faker::Name.name
       email = "example-#{n+1}@163.com"
       User.create!(:name => name, :email => email,
                    :password => "password",
                    :password_confirmation => "password")
    end
    # Step 6: Create 50 microposts per uer by limit to top six users
    User.all(:limit => 6).each do |user|
      50.times do
        user.microposts.create!(:content => Faker::Lorem.sentence(5))
      end
    end
  end
end
