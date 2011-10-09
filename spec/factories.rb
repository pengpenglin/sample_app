# By using symbol :user, we get factory girl to simulate user model

Factory.sequence :email do |n|
  "paullin81#{n}@gmail.com"
end

Factory.define :user do |user|
  user.name                    "paullin"
  user.email                   {Factory.next(:email)}
  user.password                "foobar"
  user.password_confirmation   "foobar"
end
