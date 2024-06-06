defmodule Ballot.Poll.Pollboy do
  alias Ballot.Poll
  use GenServer
  require Logger
  def start_link(args) do
    id = Keyword.get(args, :id)

    GenServer.start_link(__MODULE__,args, name: via(id))
  end
  def init(args) do
    id = Keyword.get(args, :id)
    {:ok, %{"id" => id}, {:continue, :voting}}
  end

  def handle_continue(:voting, state) do
    Logger.info("Voting initiates.....")
    candids = initiate_voting(state)
    vote = state["id"]|>Integer.parse()|>elem(0)|>Poll.get_vote()
    state = state|>Map.put("candids", candids)|> Map.put("name", vote.name)
    {:noreply, state}
  end
  def get_symbols(id) do
    GenServer.call(get_name(id), :symbols)
  end

  def result_board(id, process) do
    GenServer.cast(get_name(id), {:result_board, process})
  end

  def get_votes(id) do
    GenServer.call(get_name(id), :get_votes)
  end
  def mark_vote(id, symbol) do
    GenServer.cast(get_name(id),{:poll, symbol})
  end
  def raise_error(id) do
    GenServer.cast(get_name(id), :raise)
  end
  def handle_cast(:raise, state) do
    raise "Error"
    {:noreply, state}
  end
  def handle_cast({:poll, symbol}, state) do
    candidates = state|>Map.get("candids")
    candidate  = candidates|>Map.get(symbol)|>update_count()
    updated_state = candidates|>Map.put(symbol, candidate)|> then(&Map.put(state, "candids", &1))
    state|>Map.get("result")|>update_result()
    {:noreply, updated_state}
  end
  def handle_cast({:result_board, process}, state) do
    {:noreply, Map.put(state, "result", process)}
  end
  defp update_result(nil),do: nil
  defp update_result(process),do: send(process, :polling)

  def handle_call(:get_votes, _from, state) do
    {:reply,state ,state}
  end
  def handle_call(:symbols, _from, state) do
    {:reply, Map.keys(state),state}
  end

  defp initiate_voting(%{"id" => id}) do
    candidates = Poll.list_candidates(id)

    Enum.reduce(candidates, %{}, fn candidate, acc ->
      symbol = Map.get(candidate, :symbol)
      Map.put(acc, symbol, candidate)
    end)
  end
  defp update_count(%{poll_count: count} = candidate) do
    Map.put(candidate, :poll_count, count+1)
  end
  defp name(id), do: String.to_atom("vote_#{id}")
  defp get_name(id) do
   case Registry.lookup(Registry.Pollboy, name(id))|>Enum.at(0) do
    {pid, _} -> pid
    wrong-> wrong
   end

  end
  defp via(id) do
    {:via, Registry, {Registry.Pollboy, name(id)}}
  end
end
