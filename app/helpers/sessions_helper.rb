module SessionsHelper
  
  # This method persists user information into browser
  # for 20 years(cookies.permanent) and use secure token
  # (cookies.signed) with name "remember_token"
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user # Note that we should plus self
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil  # Note that we should plus self
  end

  # Since use may sign in by traditional way (name/password),
  # or by convenient way (remember me). The sign_in method may
  # not be called each time hence the assignment to variable 
  # @current_user would be nil.
  #
  # That require us the search the cookie by name :remember_token
  # if we can't find existing @current_user,instead of return the
  # value directly.
  #
  # So we much re-write and override the methods provided by Rails
  
  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= user_from_remember_token
  end
  
  private

    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token]||[nil,nil]
    end

end 
