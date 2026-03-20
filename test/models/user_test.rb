require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "example", email: "example@gmail.com", password: "foobar",
                      password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email ="   "
    assert_not @user.valid?
  end

  test "name should not be long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be long" do
    @user.email = "a" * 255
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.com A_US-ER@foo.bar.org
                    first.last@foo.jp alice+bob@baz.cn]

    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "Address #{valid_address.inspect} should be valid"
    end
  end

  test "email validation shoul reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]

    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid? "Address #{invalid_address.inspect} should be invalid"
    end
  end

  test "email address should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email should be saved as lowercase" do
    mixed_case_email = "Foo@EmaPle.Com"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for user with nil digest" do
    assert_not @user.authenticated?(:remember, "")
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference "Micropost.count", -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
     felix = users(:felix)
     luffy  = users(:luffy)
     assert_not felix.following?(luffy)
     felix.follow(luffy)
     assert felix.following?(luffy)
     assert luffy.followers.include?(felix)
     felix.unfollow(luffy)
     assert_not felix.following?(luffy)
     # Users can't follow themselves.
     felix.follow(felix)
     assert_not felix.following?(felix)
  end

  test "feed should have the right posts" do
      felix = users(:felix)
      luffy = users(:luffy)
      Zoro = users(:Zoro)
      # Posts from followed user
      Zoro.microposts.each do |post_following|
         assert felix.feed.include?(post_following)
      end
      # Self-posts for user with followers
      felix.microposts.each do |post_self|
        assert felix.feed.include?(post_self)
      end
      # Posts from non-followed user
      luffy.microposts.each do |post_unfollowed|
         assert_not felix.feed.include?(post_unfollowed)
      end
   end
end
