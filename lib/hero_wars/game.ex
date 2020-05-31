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

  @spec move_hero(Hero.name(), :up | :down | :left | :right) :: Hero.t()
  def move_hero(name, :up) do
    hero = HeroServer.current_state(name)
    proposed_position = {hero.x_pos, hero.y_pos - 1}

    if World.walkable?(proposed_position) do
      HeroServer.reposition(name, proposed_position)
    else
      hero
    end
  end

  def move_hero(name, :down) do
    hero = HeroServer.current_state(name)
    proposed_position = {hero.x_pos, hero.y_pos + 1}

    if World.walkable?(proposed_position) do
      HeroServer.reposition(name, proposed_position)
    else
      hero
    end
  end

  def move_hero(name, :left) do
    hero = HeroServer.current_state(name)
    proposed_position = {hero.x_pos - 1, hero.y_pos}

    if World.walkable?(proposed_position) do
      HeroServer.reposition(name, proposed_position)
    else
      hero
    end
  end

  def move_hero(name, :right) do
    hero = HeroServer.current_state(name)
    proposed_position = {hero.x_pos + 1, hero.y_pos}

    if World.walkable?(proposed_position) do
      HeroServer.reposition(name, proposed_position)
    else
      hero
    end
  end

  @spec attack(Hero.name()) :: :ok
  def attack(name) do
    hero = HeroServer.current_state(name)
    positions_to_attack = calculate_positions_to_attack({hero.x_pos, hero.y_pos})
    [{hero_pid, _}] = Registry.lookup(:hero_registry, name)

    HeroSupervisor
    |> Supervisor.which_children()
    |> Stream.map(fn {_, pid, _, _} -> pid end)
    |> Stream.filter(fn enemy_pid ->
      enemy = HeroServer.current_state(enemy_pid)
      enemy_position = {enemy.x_pos, enemy.y_pos}
      self? = enemy_pid == hero_pid

      !self? && enemy_position in positions_to_attack
    end)
    |> Stream.each(&HeroServer.update_life_status(&1, false))
    |> Stream.run()
  end

  @spec calculate_positions_to_attack(Hero.position()) :: [Hero.position()]
  defp calculate_positions_to_attack({x_pos, y_pos} = _position) do
    [
      {x_pos - 1, y_pos - 1},
      {x_pos, y_pos - 1},
      {x_pos + 1, y_pos - 1},
      {x_pos - 1, y_pos},
      {x_pos, y_pos},
      {x_pos + 1, y_pos},
      {x_pos - 1, y_pos + 1},
      {x_pos, y_pos + 1},
      {x_pos + 1, y_pos + 1}
    ]
  end
end
