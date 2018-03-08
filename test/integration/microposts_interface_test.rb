require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    # 無効な送信
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_select 'div#error_explanation'
    # 有効な送信
    content = "This micropost really ties the room together"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # 投稿を削除する
    assert_select 'a', text: '削除'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # 違うユーザーのプロフィールにアクセス (削除リンクがないことを確認)
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end
  
  test "micropost sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
    # まだマイクロポストを投稿していないユーザー
    other_user = users(:malory)
    log_in_as(other_user)
    get root_path
    assert_match "0 microposts", response.body
    other_user.microposts.create!(content: "A micropost")
    get root_path
    assert_match "1 micropost", response.body
  end
  
  #マイクロポスト検索機能
  test "micropost search" do
    log_in_as(@user)
    get root_path
    find_content = "Find my micropost"
    not_find_content = "Not find my micropost"
    assert_difference 'Micropost.count', 2 do
      post microposts_path, params: { micropost: { content: find_content } }
      post microposts_path, params: { micropost: { content: not_find_content } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_select 'form input[name=search]', count: 1
    assert_select 'form input[class*=btn-search]', count: 1
    get root_path, params: { search: find_content }
    assert_select 'span.content', find_content
    !assert_select 'span.content', not_find_content
    #他ユーザーでの検証
    other_user = users(:malory)
    log_in_as(other_user)
    get root_path, params: { search: find_content }
    assert_select 'span.content', find_content
    !assert_select 'span.content', not_find_content
    #ログアウト時の検索機能
    delete user_path(other_user)
    get root_path, params: { search: find_content }
    !assert_select 'span.content', find_content
    !assert_select 'span.content', not_find_content
  end
  
  
end
