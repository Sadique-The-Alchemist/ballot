defmodule Ballot.Poll do
  alias Ballot.Repo
  alias Ballot.Poll.Vote
  alias Ballot.Poll.Candidate
  alias Ballot.Poll.Pollboy
  import Ecto.Query

  @category_col "Candid"
  @value_col "Poll"
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
  def get_votes(vote_id) do
    Pollboy.get_votes(vote_id)
  end
  def add_result_board(id, process) do
    Pollboy.result_board(id, process)
  end

  def render_chart(result) do
    {data, color_palette}= Enum.reduce(result["candids"], {[],[]}, fn {_k, v}, acc ->

      {[[v.name,v.poll_count+1]|elem(acc,0)],[v.color| elem(acc,1)]}
    end)
    dataset  = Contex.Dataset.new(data, [@category_col, @value_col])
    opts = [
      mapping: %{category_col: @category_col, value_col: @value_col},
      colour_palette: color_palette,
      legend_setting: :legend_right,
      data_labels: false,
      title: result["name"]
    ]
   Contex.Plot.new(dataset, Contex.PieChart, 600,400, opts)
   |>Contex.Plot.to_svg()
  end

end
