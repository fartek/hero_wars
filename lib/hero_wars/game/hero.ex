defmodule HeroWars.Game.Hero do
  alias __MODULE__

  @type x_pos :: non_neg_integer
  @type y_pos :: non_neg_integer
  @type position :: {x_pos, y_pos}
  @type name :: String.t()
  @type t :: %Hero{
          x_pos: x_pos,
          y_pos: y_pos,
          alive?: boolean
        }

  defstruct x_pos: 0,
            y_pos: 0,
            alive?: false

  @spec create(position) :: Hero.t()
  def create({x_pos, y_pos} = _position) do
    %Hero{
      x_pos: x_pos,
      y_pos: y_pos,
      alive?: true
    }
  end
end
