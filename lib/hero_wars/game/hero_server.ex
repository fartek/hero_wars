defmodule HeroWars.Game.HeroServer do
  alias __MODULE__
  alias HeroWars.Game.Hero

  use GenServer

  #######
  # Api #
  #######
  @typep start_link_arg :: {:name, Hero.name()} | {:position, Hero.position()}
  @spec start_link([start_link_arg]) :: {:ok, pid} | {:error, term} | :ignore
  def start_link([name: name, position: position] = _args) do
    GenServer.start_link(HeroServer, {name, position}, name: via_tuple(name))
  end

  @spec current_state(pid | Hero.name()) :: Hero.t()
  def current_state(pid) when is_pid(pid) do
    GenServer.call(pid, :current_state)
  end

  def current_state(name) do
    GenServer.call(via_tuple(name), :current_state)
  end

  @spec reposition(Hero.name(), Hero.position()) :: Hero.t()
  def reposition(name, position) do
    GenServer.call(via_tuple(name), {:reposition, position})
  end

  @spec update_life_status(pid, boolean) :: Hero.t()
  def update_life_status(pid, alive?) do
    GenServer.call(pid, {:update_life_status, alive?})
  end

  @spec make_alive_after_timeout(pid, Hero.position(), non_neg_integer) :: no_return
  def make_alive_after_timeout(pid, new_position, respawn_timeout) do
    Process.send_after(pid, {:make_alive, new_position}, respawn_timeout)
  end

  @spec via_tuple(Hero.name()) :: {:via, Registry, {:hero_registry, Hero.name()}}
  defp via_tuple(name) do
    {:via, Registry, {:hero_registry, name}}
  end

  #############
  # Callbacks #
  #############
  @impl true
  def init({name, position}) do
    hero = Hero.create(name, position)
    {:ok, hero}
  end

  @impl true
  def handle_call(:current_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:reposition, {x_pos, y_pos}}, _from, state) do
    new_state = %Hero{state | x_pos: x_pos, y_pos: y_pos}
    {:reply, new_state, new_state}
  end

  def handle_call({:update_life_status, alive?}, _from, state) do
    new_state = %Hero{state | alive?: alive?}
    {:reply, new_state, new_state}
  end

  @impl true
  def handle_info({:make_alive, {x_pos, y_pos}}, state) do
    new_state = %Hero{state | alive?: true, x_pos: x_pos, y_pos: y_pos}
    Process.send_after(self(), :update_world, 10)
    {:noreply, new_state}
  end

  def handle_info(:update_world, state) do
    HeroWars.update_world()
    {:noreply, state}
  end
end
