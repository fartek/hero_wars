defmodule HeroWarsWeb.GameView do
  use HeroWarsWeb, :view

  def tile_color(:wall), do: "black"
  def tile_color(:empty), do: "white"
  def tile_color({:hero, _, false}), do: "red"
  def tile_color({:enemy, _, false}), do: "red"
  def tile_color({:hero, _, _}), do: "green"
  def tile_color({:enemy, _, _}), do: "yellow"
end
