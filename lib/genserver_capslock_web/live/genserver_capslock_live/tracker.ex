defmodule GenserverCapslockWeb.UserTracker do
  @moduledoc false
  use Phoenix.Presence,
    otp_app: :genserver_capslock,
    pubsub_server: GenserverCapslock.PubSub
end
