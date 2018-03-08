require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  test "full title helper" do
    assert_equal full_title, "Life Note"
    assert_equal full_title("Help"), "Help | Life Note"
  end




end