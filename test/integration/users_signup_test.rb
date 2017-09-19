require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    assert_template "users/new"
    assert_select "div#<CSS id for error explanation>"
    assert_select "div.<CSS class for field with error>"
  end
  test "valid signup information" do
    get signup_path
    follow_redirect!
    assert_template "users/show"
  end
end
