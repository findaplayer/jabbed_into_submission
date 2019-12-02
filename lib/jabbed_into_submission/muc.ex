defmodule JabbedIntoSubmission.MUC do
  alias JabbedIntoSubmission.Client

  @headers [{"Content-Type", "application/json"}]

  ### Room Administration

  @doc "List unused Rooms"
  def list(:unused, host, days) when is_bitstring(host) and is_number(days) do
    Client.post!(
      "/rooms_unused_list",
      Poison.encode!(%{host: host, days: days}),
      @headers)
  end

  @doc "List existing rooms (set the host to 'global' to get all vhosts)"
  def list(:existing, host) when is_bitstring(host),
  do: Client.post!("/muc_online_rooms", Poison.encode!(%{host: host}), @headers)

  @doc "Destroy an existing room"
  def destroy(name, service) when is_bitstring(name) and is_bitstring(service),
  do: Client.post!("/destroy_room", Poison.encode!(%{name: name, service: service}), @headers)

  @doc "Create a new room"
  def create(name, service, host), do: create(name, service, host, %{})
  def create(name, service, host, options) when is_bitstring(name) and is_bitstring(service) and is_bitstring(host) and is_map(options) do
    payload = Poison.encode!(%{
      name: name,
      service: service,
      host: host,
      options: map_to_options(options)
    })
    Client.post!("/create_room_with_opts", payload, @headers)
  end

  @doc "Change room options"
  def change_room_option(name, service, option, value) do

    payload = Poison.encode!(%{
      name: name,
      service: service,
      option: option,
      value: value
    })

    Client.post!("/change_room_option", payload, @headers)
  end

  @doc "Get the Options for a room"
  def get_options(name, service) when is_bitstring(name) and is_bitstring(service),
  do: Client.post!("/get_room_options", Poison.encode!(%{name: name, service: service}), @headers)

  ### Room Roster Management

  @doc "Subscribe to a room"
  def subscribe(user, nick, room, nodes) when is_bitstring(user) and is_bitstring(nick) and is_bitstring(room) and is_bitstring(nodes) do
    payload = Poison.encode!(%{user: user, nick: nick, room: room, nodes: nodes})
    Client.post!("/subscribe_room", payload, @headers)
  end

  @doc "Unsubscribe from a room"
  def unsubscribe(user, room) when is_bitstring(user) and is_bitstring(room),
  do: Client.post!("/unsubscribe_room", Poison.encode!(%{user: user, room: room}), @headers)

  @doc "Get the list of subscriptions for a room"
  def get_subscribers(name, service),
  do: Client.post!("/get_subscribers", Poison.encode!(%{name: name, service: service}), @headers)

  @doc "Set room affiliation one of: owner, admin, member, outcast, none"
  def set_room_affiliation(user, name, service, affiliation) when is_bitstring(user) and is_bitstring(name) and is_bitstring(service) and is_bitstring(affiliation) do
    payload = Poison.encode!(%{name: name, service: service, jid: user, affiliation: affiliation})
    Client.post!("/set_room_affiliation", payload, @headers)
  end
  
  ### Utils

  def map_to_options(options) when is_map(options) do
    Enum.reduce(options, [], fn({key, value}, acc) ->
      keypair = %{name: to_string(key), value: to_string(value)}
      acc ++ [keypair]
    end)
  end

  def options_to_map(options) when is_list(options) do
    Enum.reduce(options, %{}, fn(%{"name" => name, "value" => value}, acc) ->
      Map.merge(acc, %{name => value})
    end)
  end
end
