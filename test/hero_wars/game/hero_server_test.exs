defmodule HeroWars.Game.HeroServerTest do
  alias HeroWars.Game.HeroServer

  use ExUnit.Case, async: false

  setup do
    valid_name = "Geralt"
    invalid_name = "Max"
    valid_position = {1, 2}

    %{valid_name: valid_name, valid_position: valid_position, invalid_name: invalid_name}
  end

  describe "start_link/1" do
    test "starts a new GenServer and returns the ok tuple", context do
      result = HeroServer.start_link(name: context.valid_name, position: context.valid_position)

      assert {:ok, pid} = result
      assert is_pid(pid)
    end

    test "if GenServer with this name is already taken, return the already-started error tuple",
         context do
      result = HeroServer.start_link(name: context.valid_name, position: context.valid_position)
      assert {:ok, pid} = result

      result = HeroServer.start_link(name: context.valid_name, position: context.valid_position)
      assert {:error, {:already_started, pid_2}} = result

      assert pid == pid_2
    end
  end

  describe "current_state/1" do
    test "returns the Hero struct if a GenServer with the name exists", context do
      {:ok, _} = HeroServer.start_link(name: context.valid_name, position: context.valid_position)
      assert hero = HeroServer.current_state(context.valid_name)
      assert hero.alive?
    end

    test "EXITs if process with the name cannot be found", context do
      catch_exit do
        HeroServer.current_state(context.invalid_name)
      end
    end
  end
end
