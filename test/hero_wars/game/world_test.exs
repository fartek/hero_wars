defmodule HeroWars.Game.WorldTest do
  alias HeroWars.Game.World
  use ExUnit.Case, async: true

  setup do
    valid_position = {2, 2}
    invalid_position = {1, 3}

    %{valid_position: valid_position, invalid_position: invalid_position}
  end

  describe "walkable?/1" do
    test "returns `true` for coordinates that are not on top of a wall tile (walkable)",
         context do
      assert World.walkable?(context.valid_position)
    end

    test "returns `false` for coordinates that are on top of a wall tile (not walkable)",
         context do
      refute World.walkable?(context.invalid_position)
    end
  end

  describe "random_walkable_position/0" do
    test "returns a random position" do
      position = World.random_walkable_position()
      assert World.walkable?(position)
    end
  end
end
