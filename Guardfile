# This file show how Guard, Guard-spork and Guard-rspec
# watch files and reload them automatically, use Guard
# DSL to define whatever you want to watch

# Guard will reload Spork once below files were changed 
guard 'spork', :cli => "--drb" do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch('config/routes.rb')
  watch(%r{^config/initializers/.+\.rb$})
  watch(%r{^config/environments/.+\.rb$})
end

# Guard will reload and run the Rspec test suit once
# below files were changed
guard 'rspec', :cli => "--color --format nested --fail-fast --drb" do

  # Rails example
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec/" }
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  {"spec/controllers/"}
  watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| "spec/requests" }
  watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')                        { "spec/" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }

end
