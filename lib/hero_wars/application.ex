defmodule HeroWars.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      HeroWars.Game.HeroSupervisor,
      HeroWarsWeb.Telemetry,
      {Phoenix.PubSub, name: HeroWars.PubSub},
      HeroWarsWeb.Endpoint,
      {Registry, keys: :unique, name: :hero_registry}
    ]

    opts = [strategy: :one_for_one, name: HeroWars.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    HeroWarsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
