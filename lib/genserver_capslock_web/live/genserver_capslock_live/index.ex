defmodule GenserverCapslockWeb.GenserverCapslockLive.Index do
  @moduledoc false

  use GenserverCapslockWeb, :live_view

  alias GenserverCapslock.GlobalCapslock
  alias GenserverCapslockWeb.UserTracker

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(GenserverCapslock.PubSub, "users")
    Phoenix.PubSub.subscribe(GenserverCapslock.PubSub, "capslock")

    if connected?(socket) do
      UserTracker.track(self(), "users", socket.id, %{})
    end

    {:ok, push_event(socket, "capslock_change", %{capslock: GlobalCapslock.get()})}
  end

  @impl true
  def handle_info(%Phoenix.Socket.Broadcast{topic: "users"}, socket) do
    {:noreply, push_event(socket, "user_count", %{user_count: map_size(UserTracker.list("users"))})}
  end

  def handle_info(:capslock_change, socket) do
    {:noreply, push_event(socket, "capslock_change", %{capslock: GlobalCapslock.get()})}
  end

  @impl true
  def handle_event("capslock_change", _, socket) do
    Phoenix.PubSub.broadcast(GenserverCapslock.PubSub, "capslock", :capslock_change)
    {:noreply, push_event(socket, "capslock_change", %{capslock: GlobalCapslock.toggle()})}
  end

  @impl true
  def terminate(_reason, socket) do
    UserTracker.untrack(self(), "users", socket.id)
  end
end
