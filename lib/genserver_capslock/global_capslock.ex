defmodule GenserverCapslock.GlobalCapslock do
  @moduledoc false

  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def toggle, do: GenServer.call(__MODULE__, :toggle)
  def get, do: GenServer.call(__MODULE__, :get)

  # Callbacks
  def init(_), do: {:ok, true}

  def handle_call(:toggle, _from, state) do
    {:reply, state, not state}
  end

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end
end
