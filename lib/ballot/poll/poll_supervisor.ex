defmodule Ballot.Poll.PollSupervisor do
  use Supervisor

  alias Ballot.Poll.Pollboy
  def start_link(args) do
    id = Keyword.get(args, :id)
     Supervisor.start_link(__MODULE__, args, name: name(id) )
  end
  def init(init_arg) do
    children = [
      %{id: Pollboy, start: {Pollboy, :start_link, [init_arg]}}
    ]
    Supervisor.init(children,strategy: :one_for_one)
  end

  defp name(id), do: String.to_atom("vote_sup_#{id}")

  defp via(id) do
    {:via, Registry, {Registry.PollSup, id}}
  end
end
