defmodule Support.Doubles.HeroSupervisor do
  def start_child(_name, _position) do
    raise "This is a test double and should never be called in production"
  end
end
