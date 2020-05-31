defmodule HeroWars do
  @moduledoc """
  This is the main Hero Wars business logic context module.
  The outside world interacts with the application core solely
  through these functions.
  """

  alias HeroWars.Game
  alias HeroWars.Game.Hero

  @spec spawn_hero(Hero.name()) :: {:ok, Hero.t()} | {:error, term}
  def spawn_hero(name) do
    with {:ok, hero} <- Game.spawn_hero(name),
         update_world() do
      {:ok, hero}
    end
  end

  @spec move_hero(Hero.name(), atom) :: {:ok, Hero.t()} | {:error, term}
  def move_hero(name, direction) do
    hero = Game.move_hero(name, direction)

    with :ok <- update_world() do
      {:ok, hero}
    end
  end

  @spec perform_hero_attack(Hero.name()) :: {:ok, Hero.t()} | {:error, term}
  def perform_hero_attack(name) do
    with :ok <- Game.attack(name) do
      update_world()
    end
  end

  @spec get_game_state(Hero.name()) ::
          {[[:wall | :empty | {:hero | :enemy, Hero.name(), boolean}]], boolean}
  def get_game_state(hero_name) do
    heroes = Game.list_heroes()
    {current_hero, enemies} = Enum.reduce(heroes, {nil, []}, &separate_heroes(&1, &2, hero_name))
    world = Game.world_with_current_hero_and_enemies(current_hero, enemies)

    {world, current_hero.alive?}
  end

  @spec separate_heroes(Hero.t(), {Hero.t(), [Hero.t()]}, Hero.name()) :: {Hero.t(), [Hero.t()]}
  defp separate_heroes(%Hero{name: name} = hero, {_, enemies}, name), do: {hero, enemies}

  defp separate_heroes(hero, {current_hero, enemies}, _hero_name) do
    {current_hero, [hero | enemies]}
  end

  @spec listen_for_updates :: :ok | {:error, term}
  def listen_for_updates do
    Phoenix.PubSub.subscribe(HeroWars.PubSub, "game")
  end

  @spec update_world :: :ok | {:error, term}
  def update_world do
    Phoenix.PubSub.broadcast(HeroWars.PubSub, "game", :update_world)
  end
end
