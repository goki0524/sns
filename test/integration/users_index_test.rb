require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin     = users(:michael)
    @non_admin = users(:archer)
    @user1     = users(:lana)
    @user2     = users(:malory)
  end
  
  #管理者でdeleteリンクがあるか.ページネーションも含めたテスト
  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: '削除'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end
  
  #管理者じゃないユーザーでdeleteリンクがないか
  test "index as non_admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
  
  #ユーザー検索機能
  test "user search" do
    log_in_as(@admin)
    get users_path
    assert_select 'form input[name=search]', count: 1
    assert_select 'form input[class*=btn]', count: 1
    get users_path, params: { search: "lana" }
    assert_select 'a[href=?]', user_path(@user1), text: @user1.name, count: 1
    assert_select 'a[href=?]', user_path(@user2), text: @user2.name, count: 0
    get users_path, params: { search: "malory" }
    assert_select 'a[href=?]', user_path(@user1), text: @user1.name, count: 0
    assert_select 'a[href=?]', user_path(@user2), text: @user2.name, count: 1
    get users_path, params: { search: "m" }
    assert_select 'a[href=?]', user_path(@admin), text: @admin.name, count: 1
    assert_select 'a[href=?]', user_path(@non_admin), text: @non_admin.name, count: 0
    assert_select 'a[href=?]', user_path(@user1), text: @user1.name, count: 0
    assert_select 'a[href=?]', user_path(@user2), text: @user2.name, count: 1
  end
  
end
