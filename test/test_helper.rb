require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"

class ActiveSupport
  class TestCase
    fixtures :all
    def is_logged_in?
      !session[:user_id].nil?
    end
  end
end
