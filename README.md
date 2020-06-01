# HeroWars

## Requirements

- [asdf](https://github.com/asdf-vm/asdf) version manager
- [erlang](https://github.com/asdf-vm/asdf-erlang), [elixir](https://github.com/asdf-vm/asdf-elixir) and [nodejs](https://github.com/asdf-vm/asdf-nodejs) plugins for asdf

## Project environment setup

1. `git clone` this repo
2. `cd` into the project directory
3. run `asdf install`

## Running tests

```elixir
mix test
```

## Running a development build

```elixir
iex -S mix phx.server
```

The project then becomes available at http://localhost:4000/game.

## Building a release with Releases

From the project root:

1. `mix phx.gen.secret`
2. `export SECRET_KEY_BASE=the-secret-from-step-1`
3. `mix deps.get --only prod`
4. `MIX_ENV=prod mix compile`
5. `npm install --prefix ./assets`
6. `npm run deploy --prefix ./assets`
7. `mix phx.digest`
8. `MIX_ENV=prod mix release`

For a more detailed description visit [the Phoenix docs](https://hexdocs.pm/phoenix/releases.html#content)

## The deployed version

The deployed version can be reached at [Heroku](https://vast-oasis-14727.herokuapp.com/game)
