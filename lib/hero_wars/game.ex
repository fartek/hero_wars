defmodule HeroWars.Game do
  @moduledoc """
  This is the Game context module. This module contains functions
  for dealing with heros and their lifecycles.
  """

  alias HeroWars.Game.{Hero, HeroServer, HeroSupervisor, World}

  @spec spawn_hero(Hero.name()) :: {:ok, Hero.t()} | {:error, term}
  def spawn_hero(name) do
    hero_server_module = Application.get_env(:hero_wars, :modules)[:hero_server] || HeroServer
    world_module = Application.get_env(:hero_wars, :modules)[:world] || World

    hero_supervisor_module =
      Application.get_env(:hero_wars, :modules)[:hero_supervisor] || HeroSupervisor

    position = world_module.random_walkable_position()

    case hero_supervisor_module.start_child(name, position) do
      {:ok, _pid} ->
        hero = hero_server_module.current_state(name)
        {:ok, hero}

      {:error, {:already_started, _pid}} ->
        hero = hero_server_module.current_state(name)
        {:ok, hero}

      _ ->
        {:error, :cannot_spawn_hero}
    end
  end
end
