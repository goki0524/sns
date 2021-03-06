require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael) #usersはfixturesのusers.ymlを参照している
  end
  
  #不適切な情報を送りlogin機能をテスト
  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: {session: {email: "", password: ""} }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
  
  #適切な情報を送りlogin/logoutできるかテスト
   test "login with valid information followed by logout" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: {session: {email: @user.email, password: "password"} }
    assert is_logged_in?
    assert_redirected_to root_url #redirect先が正しいかチェック
    follow_redirect! #実際にredirectする
    assert_template '/'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # 2番目のウィンドウでログアウトをクリックするユーザーをシミュレートする
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
    assert_select "a[href=?]", login_path
  end
  
  # digestがnilの場合のテスト
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
  
  #チェックボックステスト
  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    #assigns(:user)はsessions/controller createの@user
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end
  
  
  test "login without remembering" do
    # クッキーを保存してログイン
    log_in_as(@user, remember_me: '1')
    delete logout_path
    # クッキーを削除してログイン
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end
  
end
