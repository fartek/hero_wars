use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :hero_wars, HeroWarsWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :hero_wars,
  modules: [
    hero_supervisor: Support.Doubles.HeroSupervisor,
    hero_server: Support.Doubles.HeroServer,
    world: Support.Doubles.World
  ],
  test_utils: [default_otp_app: :hero_wars]
