defmodule HeroWars.Game.HeroSupervisor do
  alias __MODULE__
  alias HeroWars.Game.{HeroServer, World}

  use DynamicSupervisor

  @spec start_link(any) :: {:ok, pid} | {:error, term} | :ignore
  def start_link(_args) do
    DynamicSupervisor.start_link(HeroSupervisor, nil, name: HeroSupervisor)
  end

  @type child_result :: {:ok, pid} | {:error, term} | :ignore
  @spec start_child(Hero.name(), Hero.position()) :: child_result
  def start_child(name, position) do
    spec = {HeroServer, id: name, position: position}
    DynamicSupervisor.start_child(HeroSupervisor, spec)
  end

  @impl true
  def init(_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
