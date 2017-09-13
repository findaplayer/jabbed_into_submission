defmodule JabbedIntoSubmission.MUCTest do
  use ExUnit.Case, async: false
  alias JabbedIntoSubmission.{MUC, User}
  doctest MUC

  @host     "localhost"
  @muc_host "rooms-chat-staging.#{@host}"
  @room     "dummy"
  @nodes    "urn:xmpp:mucsub:nodes:messages,urn:xmpp:mucsub:nodes:affiliations"
  @user     "dummy_user"
  @device   "#{@user}@#{@host}/dummydevice"
  @room_jid "#{@room}@#{@muc_host}"

  setup do
    # Delete all groups
    User.unregister(@user, @host)
    MUC.unsubscribe(@device, @room_jid)
    MUC.destroy(@room, @muc_host)
    :ok
  end

  describe "MUC" do
    test "List unused" do
      res = MUC.list(:unused, @muc_host, 5)
      assert res.status_code == 200
    end

    test "List existing" do
      res = MUC.list(:existing, @muc_host)
      assert res.status_code == 200
    end

    test "Destroy" do
      MUC.create(@room, @muc_host, @host)
      res = MUC.destroy(@room, @muc_host)
      assert res.body == 0
      assert res.status_code == 200
    end

    test "Create with options" do
      res = MUC.create(@room, @muc_host, @host, %{title: "Title", allow_subscription: true})
      assert res.body == 0
      assert res.status_code == 200
    end

    test "MUC options" do
      assert MUC.create(@room, @muc_host, @host, %{title: "Title", allow_subscription: true}).body == 0
      res = MUC.get_options(@room, @muc_host)
      assert res.status_code == 200
    end

    test "subscribe & unsubscribe" do
      assert MUC.create(@room, @muc_host, @host, %{title: "Title", allow_subscription: true, persistent: true}).body == 0
      assert User.register(@user, @host, "password").body == "User dummy_user@localhost successfully registered"

      assert MUC.get_subscribers(@room, @muc_host).body == []

      assert MUC.subscribe(@device, @user, @room_jid, @nodes).status_code == 200

      assert MUC.get_subscribers(@room, @muc_host).body == ["#{@user}@#{@host}"]

      assert MUC.unsubscribe(@device, "#{@room}@#{@muc_host}").body == 0

      assert MUC.get_subscribers(@room, @muc_host).body == []
    end
  end

  describe "Options" do
    test "Map -> Options" do
      # Format the string, then for each element in the returning list,
      # Emit a message to self with the current element - so that
      # the contents can be asserted without caring about the order.
      JabbedIntoSubmission.MUC.map_to_options(
        %{hello: "world", lorem: "ipsum", yes: true, number: 1337})
        |> Enum.each(fn(x) ->
        send self(), {:option, x}
      end)

      assert_receive {:option, %{name: "hello",  value: "world"}}
      assert_receive {:option, %{name: "lorem",  value: "ipsum"}}
      assert_receive {:option, %{name: "yes",    value: "true"}}
      assert_receive {:option, %{name: "number", value: "1337"}}
    end

    test "Options -> Map" do
      options = [
        %{"name" => "title", "value" => "Title"},
        %{"name" => "description", "value" => ""},
        %{"name" => "allow_change_subj", "value" => "true"},
        %{"name" => "voice_request_min_interval", "value" => "1800"},
        %{"name" => "captcha_whitelist", "value" => "{0,nil}"}]

      JabbedIntoSubmission.MUC.options_to_map(options)
      |> Enum.each(fn(x) ->
        send self(), {:pair, x}
      end)

      assert_receive {:pair, {"title", "Title"}}
      assert_receive {:pair, {"description", ""}}
      assert_receive {:pair, {"allow_change_subj", "true"}}
      assert_receive {:pair, {"voice_request_min_interval", "1800"}}
      assert_receive {:pair, {"captcha_whitelist", "{0,nil}"}}
    end
  end
end
