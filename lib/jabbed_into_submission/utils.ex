defmodule JabbedIntoSubmission.Utils do
  alias JabbedIntoSubmission.Client

  @headers [{"Content-Type", "application/json"}]

  ### General Ejabberd Admin Tasks

  @doc "Send Stanza c2s"
  def send_stanza_c2s(user, host, resource, stanza) when is_bitstring(user) and is_bitstring(host) do
    
    payload = Poison.encode!(%{
      "user": user,
      "host": host,
      "resource": resource,
      "stanza": stanza
    })

    Client.post!("/send_stanza_c2s", payload, @headers)
  end

  @doc "Send Stanza"
  def send_stanza(from, to, stanza) when is_bitstring(from) and is_bitstring(to) do
    
    payload = Poison.encode!(%{
      "from": from,
      "to": to,
      "stanza": stanza
    })

    Client.post!("/send_stanza", payload, @headers)
  end

  @doc "Set loglevel"
  def set_loglevel(loglevel) do
    
    payload = Poison.encode!(%{
      "loglevel": loglevel
    })

    Client.post!("/set_loglevel", payload, @headers)
  end

end
