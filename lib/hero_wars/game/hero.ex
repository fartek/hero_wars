defmodule HeroWars.Game.Hero do
  alias __MODULE__

  @type x_pos :: non_neg_integer
  @type y_pos :: non_neg_integer
  @type position :: {x_pos, y_pos}
  @type name :: String.t()
  @type t :: %Hero{
          x_pos: x_pos,
          y_pos: y_pos,
          name: name,
          alive?: boolean
        }

  defstruct x_pos: 0,
            y_pos: 0,
            name: "",
            alive?: false

  @spec create(name, position) :: Hero.t()
  def create(name, {x_pos, y_pos} = _position) do
    %Hero{
      x_pos: x_pos,
      y_pos: y_pos,
      name: name,
      alive?: true
    }
  end

  @adjectives ~w[silly happy dangerous crazy dancing swift hungry poisonous]
  @nouns ~w[pickle gangsta dragon killer sicario rapper santa anaconda virus]

  @spec random_name :: name
  def random_name do
    random_adjective = Enum.random(@adjectives)
    random_noun = Enum.random(@nouns)

    "#{random_adjective}_#{random_noun}"
  end
end
