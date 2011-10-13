require 'spec_helper'

describe "FriendlyForwardings" do

  it "Should redirect to requested page after sign in" do
    user = Factory(:user)
    visit edit_user_path(user) # Should redirect to sign in page
    fill_in :email,    :with => user.email
    fill_in :password, :with => user.password
    click_button # should sign in and redirec to requrested page
    response.should render_template("users/edit")
  end
end
