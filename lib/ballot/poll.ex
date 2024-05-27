defmodule Ballot.Poll do
  alias Ballot.Repo
  alias Ballot.Poll.Vote
  alias Ballot.Poll.Candidate
  alias Ballot.Poll.Pollboy
  import Ecto.Query

  def get_vote(vote_id) do
    Vote
    |> Repo.get(vote_id)
    |> Repo.preload(:candidate)
  end

  def list_candidates(vote_id) do
    from(c in Candidate, where: c.vote_id == ^vote_id) |> Repo.all()
  end
  def start_vote(vote_id) do
    Ballot.Unit.start_vote(vote_id)
  end
  def mark_vote(vote_id, symbol) do
    Pollboy.mark_vote(vote_id,symbol)
  end
end
