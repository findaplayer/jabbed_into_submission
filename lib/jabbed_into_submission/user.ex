defmodule JabbedIntoSubmission.User do
  alias JabbedIntoSubmission.Client

  @headers [{"Content-Type", "application/json"}]

  ### User Administration

  @doc "Register a user"
  def register(user, host, password) when is_bitstring(user) and is_bitstring(host) and is_bitstring(password) do
    payload = Poison.encode!(%{
          user: user,
          host: host,
          password: password
    })
    Client.post!("/register", payload, @headers)
  end

  @doc "Unregister (delete) a user"
  def unregister(user, host) when is_bitstring(user) and is_bitstring(host),
  do: Client.post!("/unregister", Poison.encode!(%{user: user, host: host}), @headers)

  @doc "Change a user's password"
  def change_password(user, host, new_pass),
  do: Client.post!("/change_password", Poison.encode!(%{user: user, host: host, newpass: new_pass}), @headers)

  @doc "STUB"
  def rooms(_user, _host) do
    :stub
  end

  @doc "STUB"
  def list(_host) do
    :stub
  end

  @doc "STUB"
  def ban(_user, _host, _reason) do
    :stub
  end

  def block_users(user, host, block_list) do

    list_items = Enum.map( Enum.with_index(block_list), fn({userid,index}) -> 
"<item type='jid' value='user_#{userid}@#{host}' action='deny' order='#{index}'/>" end) |> Enum.join("")

    xml_block_list_query = "<query xmlns='jabber:iq:privacy'><list name='#{user}_block_list'>"
                <>
                list_items
                <>
                "</list></query>"

    Client.post!("/privacy_set", Poison.encode!(%{user: user, host: host, xmlquery: xml_block_list_query}), @headers)
  end

  @doc "Set the users default privacy list based on xmpp username"
  def set_block_list_default(user, host) do
    
    xml_query = "<query xmlns='jabber:iq:privacy'>
      <default name='#{user}_block_list'/>
    </query>"

    Client.post!("/privacy_set", Poison.encode!(%{user: user, host: host, xmlquery: xml_query}), @headers)

  end

  @doc "Set the users default privacy list based on xmpp username"
  def set_block_list_active(user, host) do
    
    xml_query = "<query xmlns='jabber:iq:privacy'>
      <active name='#{user}_block_list'/>
    </query>"

    Client.post!("/privacy_set", Poison.encode!(%{user: user, host: host, xmlquery: xml_query}), @headers)

  end

end
