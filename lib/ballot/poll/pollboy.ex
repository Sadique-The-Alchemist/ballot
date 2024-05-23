defmodule Ballot.Poll.Pollboy do
  alias Ballot.Poll
  use GenServer
  require Logger
  def start_link(args) do
    id = Keyword.get(args, :id)
    Logger.info("Voting initiates")
    GenServer.start_link(__MODULE__,args, name: name(id))
  end
  def init(args) do
    Logger.info("Voting initiates init")
    id = Keyword.get(args, :id)
    {:ok, %{"id" => id}, {:continue, :voting}}
  end

  def handle_continue(:voting, state) do
    Logger.info("Voting initiates continues")
    state = initiate_voting(state)
    {:noreply, state}
  end
  def get_state(id) do
    GenServer.call(name(id),:get_state)
  end
  def get_symbols(id) do
    GenServer.call(name(id), :symbols)
  end

  def get_votes(id) do
    GenServer.call(name(id), :get_votes)
  end
  def mark_vote(id, symbol) do
    GenServer.cast(name(id),{:poll, symbol})
  end
  def raise_error(id) do
    GenServer.cast(name(id), :raise)
  end
  def handle_cast(:raise, state) do
    raise "Error"
    {:noreply, state}
  end
  def handle_cast({:poll, symbol}, state) do
    candidate = state|>Map.get(symbol)|>update_count()
    updated_state = Map.put(state, symbol, candidate)
    {:noreply, updated_state}
  end

  def handle_call(:get_votes, _from, state) do
    votes =
    state
    |>Map.pop("id")
    |>elem(1)
    |>Enum.reduce(%{}, fn {k,v}, acc ->
      count = Map.get(v,:poll_count)
      Map.put(acc, k, count)
    end)
    {:reply, votes,state}
  end
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end
  def handle_call(:symbols, _from, state) do
    {:reply, Map.keys(state),state}
  end

  defp initiate_voting(%{"id" => id} = state) do
    candidates = Poll.list_candidates(id)

    Enum.reduce(candidates, state, fn candidate, acc ->
      symbol = Map.get(candidate, :symbol)
      Map.put(acc, symbol, candidate)
    end)
  end
  defp update_count(%{poll_count: count} = candidate) do
    Map.put(candidate, :poll_count, count+1)
  end
  defp name(id), do: String.to_atom("vote_#{id}")
  defp via(id) do
    {:via, Registry, {Registry.Pollboy, id}}
  end
end
