defmodule JabbedIntoSubmission.UserTest do
  use ExUnit.Case, async: false
  alias JabbedIntoSubmission.User
  doctest User

  @host     "localhost"
  @user     "dummy_user"

  setup do
    User.unregister(@user, @host)
    :ok
  end

  describe "User Admin" do
    test "Register" do
      assert User.register(@user, @host, "password").body == "User dummy_user@localhost successfully registered"
    end

    test "Unregister" do
      assert User.register(@user, @host, "password").body == "User dummy_user@localhost successfully registered"
      User.unregister(@user, @host)
    end

    test "Change Password" do
      assert User.register(@user, @host, "password").body == "User dummy_user@localhost successfully registered"
      assert User.change_password(@user, @host, "password2").body == 0
    end

    test "block_users" do
      User.block_users(@user, @host, [23456,23456,123458])
    end

  end
end
