# By using symbol :user, we get factory girl to simulate user model

Factory.sequence :email do |n|
  "paullin81-#{n}@gmail.com"
end

Factory.define :user do |user|
  user.name                    "paullin"
  user.email                   "paullin81@gmail.com"
  user.password                "foobar"
  user.password_confirmation   "foobar"
end

# Also we can use another mechanisam
#
# Factory.define :user do |user|
#   ...
#   user.email {Factory.next(:email)}
# end
#
# Then we don't need to explicit invoke:
#  Factory(:user, :email => Factory.next(:email))
# in Rspec testing code
