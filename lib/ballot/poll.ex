defmodule Ballot.Poll do
  alias Ballot.Repo
  alias Ballot.Poll.Vote
  alias Ballot.Poll.Candindate
  import Ecto.Query

  def get_vote(vote_id) do
    Vote
    |> Repo.get(vote_id)
    |> Repo.preload(:candidate)
  end

  def list_candidates(vote_id) do
    from(c in Candindate, where: c.vote_id == ^vote_id) |> Repo.all()
  end
end
