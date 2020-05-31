defmodule HeroWars.Game.HeroTest do
  alias HeroWars.Game.Hero
  use ExUnit.Case, async: true

  describe "create/1" do
    test "creates a hero with the provided position" do
      hero = Hero.create("Geralt", {4, 5})
      assert hero.x_pos == 4
      assert hero.y_pos == 5
    end

    test "created hero is alive" do
      hero = Hero.create("Geralt", {4, 5})
      assert hero.alive?
    end

    test "created hero has a name" do
      hero = Hero.create("Geralt", {4, 5})
      assert hero.name == "Geralt"
    end
  end
end
