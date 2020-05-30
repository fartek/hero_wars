defmodule HeroWars.Game.World do
  @moduledoc """
  This module encompases the world map and the functions
  that operate with it.

  Tiles:
  0 - walkable/empty tile
  1 - wall tile
  """

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

  @type x_pos :: non_neg_integer
  @type y_pos :: non_neg_integer
  @type position :: {x_pos, y_pos}

  @spec walkable?(position) :: boolean
  def walkable?({x_pos, y_pos}) do
    tile = @world |> Enum.at(y_pos) |> Enum.at(x_pos)
    tile == 0
  end

  @doc """
  Note: for demo purposes, it is assumed that this function
  can never fail and returns a result in ~constant time.
  """
  @spec random_walkable_position :: position
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
end
