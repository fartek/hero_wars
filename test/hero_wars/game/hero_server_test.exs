defmodule HeroWars.Game.HeroServerTest do
  alias HeroWars.Game.HeroServer

  use ExUnit.Case, async: false

  setup do
    valid_id = "Geralt"
    invalid_id = "Max"
    valid_position = {1, 2}

    %{valid_id: valid_id, valid_position: valid_position, invalid_id: invalid_id}
  end

  describe "start_link/1" do
    test "starts a new GenServer and returns the ok tuple", context do
      result = HeroServer.start_link(id: context.valid_id, position: context.valid_position)

      assert {:ok, pid} = result
      assert is_pid(pid)
    end

    test "if GenServer with this name is already taken, return the already-started error tuple",
         context do
      result = HeroServer.start_link(id: context.valid_id, position: context.valid_position)
      assert {:ok, pid} = result

      result = HeroServer.start_link(id: context.valid_id, position: context.valid_position)
      assert {:error, {:already_started, pid_2}} = result

      assert pid == pid_2
    end
  end

  describe "current_state/1" do
    test "returns the Hero struct if a GenServer with the id exists", context do
      {:ok, _} = HeroServer.start_link(id: context.valid_id, position: context.valid_position)
      assert hero = HeroServer.current_state(context.valid_id)
      assert hero.alive?
    end

    test "EXITs if process with the id cannot be found", context do
      catch_exit do
        HeroServer.current_state(context.invalid_id)
      end
    end
  end
end
