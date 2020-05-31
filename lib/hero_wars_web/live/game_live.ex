defmodule HeroWarsWeb.GameLive do
  alias HeroWars.Game.Hero
  alias HeroWarsWeb.{GameView, GameLive}
  alias HeroWarsWeb.Router.Helpers, as: Routes

  use Phoenix.LiveView

  def render(assigns) do
    Phoenix.View.render(GameView, "index.html", assigns)
  end

  def mount(%{"name" => hero_name}, _session, socket) do
    if connected?(socket) do
      HeroWars.listen_for_updates()

      with {:ok, hero} <- HeroWars.spawn_hero(hero_name) do
        assigns = [hero: hero, loading?: true]
        {:ok, assign(socket, assigns)}
      else
        _ ->
          raise "Could not spawn hero #{inspect(hero_name)}"
      end
    else
      {:ok, assign(socket, :loading?, true)}
    end
  end

  def mount(_params, _session, socket) do
    hero_name = Hero.random_name()
    {:ok, push_redirect(socket, to: Routes.live_path(socket, GameLive, name: hero_name))}
  end

  def handle_event("try-move", %{"key" => "ArrowUp"}, socket) do
    hero_name = socket.assigns.hero.name
    HeroWars.move_hero(hero_name, :up)
    {:noreply, socket}
  end

  def handle_event("try-move", %{"key" => "ArrowDown"}, socket) do
    hero_name = socket.assigns.hero.name
    HeroWars.move_hero(hero_name, :down)
    {:noreply, socket}
  end

  def handle_event("try-move", %{"key" => "ArrowLeft"}, socket) do
    hero_name = socket.assigns.hero.name
    HeroWars.move_hero(hero_name, :left)
    {:noreply, socket}
  end

  def handle_event("try-move", %{"key" => "ArrowRight"}, socket) do
    hero_name = socket.assigns.hero.name
    HeroWars.move_hero(hero_name, :right)
    {:noreply, socket}
  end

  def handle_event("try-move", _params, socket), do: {:noreply, socket}

  def handle_event("try-attack", %{"key" => " "}, socket) do
    hero_name = socket.assigns.hero.name
    HeroWars.perform_hero_attack(hero_name)
    {:noreply, socket}
  end

  def handle_event("try-attack", _params, socket), do: {:noreply, socket}

  def handle_info(:update_world, socket) do
    hero_name = socket.assigns.hero.name
    {world, alive?} = HeroWars.get_game_state(hero_name)

    assigns = [world: world, loading?: false, alive?: alive?]
    {:noreply, assign(socket, assigns)}
  end
end
