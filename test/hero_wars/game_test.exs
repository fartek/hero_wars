defmodule HeroWars.GameTest do
  alias HeroWars.Game
  alias HeroWars.Game.Hero
  alias Support.TestUtils

  use ExUnit.Case, async: false

  defmodule WorldSuccess do
    def random_walkable_position do
      send(self(), :world_success_random_walkable_position)
      {1, 2}
    end
  end

  defmodule HeroSupervisorSuccess do
    def start_child(name, position) do
      send(self(), {:hero_supervisor_success_start_child, {name, position}})
      {:ok, :pid}
    end
  end

  defmodule HeroSupervisorAlreadyStarted do
    def start_child(name, position) do
      send(self(), {:hero_supervisor_already_started_start_child, {name, position}})
      {:error, {:already_started, :pid}}
    end
  end

  defmodule HeroSupervisorError do
    def start_child(name, position) do
      send(self(), {:hero_supervisor_error_start_child, {name, position}})
      {:error, :supervisor_error}
    end
  end

  defmodule HeroServerSuccess do
    def current_state(name) do
      send(self(), {:hero_server_success_current_state, name})
      %Hero{x_pos: 3, y_pos: 4, alive?: true}
    end
  end

  setup do
    valid_name = "Geralt"
    %{valid_name: valid_name}
  end

  describe "spawn_hero/1" do
    test "returns an ok-tuple with the Hero struct if successfully spawned", context do
      TestUtils.set_temp_config_value(:modules, :hero_supervisor, HeroSupervisorSuccess)
      TestUtils.set_temp_config_value(:modules, :hero_server, HeroServerSuccess)
      TestUtils.set_temp_config_value(:modules, :world, WorldSuccess)

      assert {:ok, hero} = Game.spawn_hero(context.valid_name)
      assert hero.x_pos == 3
      assert hero.y_pos == 4
      assert hero.alive?

      expected_name = context.valid_name
      expected_position = {1, 2}

      assert_received(:world_success_random_walkable_position)

      assert_received(
        {:hero_supervisor_success_start_child, {^expected_name, ^expected_position}}
      )

      assert_received({:hero_server_success_current_state, ^expected_name})
    end

    test "returns an ok-tuple with the Hero struct if hero with name already exists", context do
      TestUtils.set_temp_config_value(:modules, :hero_supervisor, HeroSupervisorAlreadyStarted)
      TestUtils.set_temp_config_value(:modules, :hero_server, HeroServerSuccess)
      TestUtils.set_temp_config_value(:modules, :world, WorldSuccess)

      assert {:ok, hero} = Game.spawn_hero(context.valid_name)
      assert hero.x_pos == 3
      assert hero.y_pos == 4
      assert hero.alive?

      expected_name = context.valid_name
      expected_position = {1, 2}

      assert_received(
        {:hero_supervisor_already_started_start_child, {^expected_name, ^expected_position}}
      )

      assert_received({:hero_server_success_current_state, ^expected_name})
    end

    test "returns and error tuple if cannot spawn hero", context do
      TestUtils.set_temp_config_value(:modules, :hero_supervisor, HeroSupervisorError)
      TestUtils.set_temp_config_value(:modules, :world, WorldSuccess)

      assert Game.spawn_hero(context.valid_name) == {:error, :cannot_spawn_hero}

      expected_name = context.valid_name
      expected_position = {1, 2}
      assert_received({:hero_supervisor_error_start_child, {^expected_name, ^expected_position}})
    end
  end
end
