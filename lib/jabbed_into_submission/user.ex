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

  @doc "STUB"
  def rooms(_user, _host) do
    :stub
  end

  @doc "STUB"
  def change_password(_user, _host, _new_pass) do
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
end