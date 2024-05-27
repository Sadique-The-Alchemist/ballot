defmodule Ballot.Poll.PollSupervisor do
  use Supervisor

  alias Ballot.Poll.Pollboy
  def start_link(args) do
     Supervisor.start_link(__MODULE__, args)
  end
  def init(init_arg) do
    children = [
      %{id: Pollboy, start: {Pollboy, :start_link, [init_arg]}}
    ]
    Supervisor.init(children,strategy: :one_for_one)
  end


end
