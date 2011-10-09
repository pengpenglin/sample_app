class ApplicationController < ActionController::Base
  protect_from_forgery
  # Here we explicit include the SessionHelper, than all
  # inherited controllers will automatically include the
  # helper to have the abilitiy to controller the session
  include SessionsHelper
end
