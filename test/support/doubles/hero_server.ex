defmodule Support.Doubles.HeroServer do
  def current_state(_name) do
    raise "This is a test double and should never be called in production"
  end
end
