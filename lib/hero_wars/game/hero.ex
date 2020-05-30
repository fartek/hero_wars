defmodule HeroWars.Game.Hero do
  alias __MODULE__
  alias HeroWars.Game.World

  @type t :: %Hero{
          x_pos: World.x_pos(),
          y_pos: World.y_pos(),
          alive?: boolean
        }
  defstruct x_pos: 0,
            y_pos: 0,
            alive?: false

  @spec create(World.position()) :: Hero.t()
  def create({x_pos, y_pos} = _position) do
    %Hero{
      x_pos: x_pos,
      y_pos: y_pos,
      alive?: true
    }
  end
end
