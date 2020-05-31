defmodule HeroWars.Game.World do
  @moduledoc """
  This module encompases the world map and the functions
  that operate with it.

  Tiles:
  0 - walkable/empty tile
  1 - wall tile
  """

  alias HeroWars.Game.Hero

  @world [
    [1, 1, 1, 1, 1, 1, 1, 1],
    [1, 0, 0, 0, 0, 0, 0, 1],
    [1, 0, 0, 0, 0, 0, 0, 1],
    [1, 1, 1, 1, 1, 0, 0, 1],
    [1, 0, 0, 0, 1, 0, 0, 1],
    [1, 0, 0, 0, 0, 0, 0, 1],
    [1, 1, 1, 1, 1, 1, 1, 1]
  ]

  @world_width @world |> Enum.at(0) |> length()
  @world_height length(@world)

  @spec walkable?(Hero.position()) :: boolean
  def walkable?({x_pos, y_pos} = _position) do
    tile = @world |> Enum.at(y_pos) |> Enum.at(x_pos)
    tile == 0
  end

  @doc """
  Note: for demo purposes, it is assumed that this function
  can never fail and returns a result in ~constant time.
  """
  @spec random_walkable_position :: Hero.position()
  def random_walkable_position do
    max_x = @world_width - 1
    max_y = @world_height - 1

    random_x = Enum.random(0..max_x)
    random_y = Enum.random(0..max_y)

    suggested_position = {random_x, random_y}

    if walkable?(suggested_position) do
      suggested_position
    else
      random_walkable_position()
    end
  end

  @spec get_world_map :: [[:empty | :wall]]
  def get_world_map do
    Enum.map(@world, fn line -> Enum.map(line, &handle_map_tile/1) end)
  end

  @spec handle_map_tile(non_neg_integer) :: :empty | :wall
  defp handle_map_tile(0), do: :empty
  defp handle_map_tile(1), do: :wall
end
