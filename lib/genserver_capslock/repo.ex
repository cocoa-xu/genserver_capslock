defmodule GenserverCapslock.Repo do
  use Ecto.Repo,
    otp_app: :genserver_capslock,
    adapter: Ecto.Adapters.Postgres
end
