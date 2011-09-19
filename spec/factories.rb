# By using symbol :user, we get factory girl to simulate user model

Factory.define :user do |user|
  user.name                    "Paul"
  user.email                   "pengpenglin@163.com"
  user.password                "foobar"
  user.password_confirmation   "foobar"
end
