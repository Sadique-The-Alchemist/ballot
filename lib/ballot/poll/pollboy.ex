defmodule Ballot.Poll.Pollboy do
  alias Ballot.Poll
  use GenServer

  def init(vote_id) do
    {:ok, %{"id" => vote_id}, {:continue, :voting}}
  end

  def handle_continue(:voting, state) do
    state = initiate_voting(state)
    {:noreply, state}
  end

  def handle_cast({:poll, symbol}, state) do
    candidate = state|>Map.get(symbol)|>update_count()
    updated_state = Map.put(state, symbol, candidate)
    {:noreply, updated_state}
  end

  defp initiate_voting(%{"id" => id} = state) do
    candidates = Poll.list_candidates(id)

    Enum.reduce(candidates, state, fn candidate, acc ->
      symbol = Map.get(candidate, :symbol)
      Map.put(acc, symbol, candidate)
    end)
  end
  defp update_count(%{vote_count: count} = candidate) do
    Map.put(candidate, :vote_count, count+1)
  end
end
