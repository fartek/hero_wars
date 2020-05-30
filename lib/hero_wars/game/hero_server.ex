defmodule HeroWars.Game.HeroServer do
  alias __MODULE__
  alias HeroWars.Game.Hero

  use GenServer

  #######
  # Api #
  #######
  @typep start_link_arg :: {:name, Hero.name()} | {:position, Hero.position()}
  @spec start_link([start_link_arg]) :: {:ok, pid} | {:error, term} | :ignore
  def start_link([name: name, position: position] = _args) do
    GenServer.start_link(HeroServer, position, name: via_tuple(name))
  end

  @spec current_state(Hero.name()) :: Hero.t()
  def current_state(name) do
    GenServer.call(via_tuple(name), :current_state)
  end

  @spec via_tuple(Hero.name()) :: {:via, Registry, {:hero_registry, Hero.name()}}
  defp via_tuple(name) do
    {:via, Registry, {:hero_registry, name}}
  end

  #############
  # Callbacks #
  #############
  @impl true
  def init(position) do
    hero = Hero.create(position)
    {:ok, hero}
  end

  @impl true
  def handle_call(:current_state, _from, state) do
    {:reply, state, state}
  end
end
