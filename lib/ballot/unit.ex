defmodule Ballot.Unit do
  use DynamicSupervisor
  alias Ballot.Poll.Pollboy
  alias Ballot.Poll.Pollboy
  require Logger

  def start_link(args) do
    Logger.info("Unit started")
    DynamicSupervisor.start_link(__MODULE__,args, name: Ballot.UnitRunner)
  end

  def start_vote(vote_id) do
    spec = {Pollboy, id: vote_id}
    DynamicSupervisor.start_child(Ballot.UnitRunner,spec)
  end

  def init(init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one, extra_arguments: [init_arg])
  end
end
