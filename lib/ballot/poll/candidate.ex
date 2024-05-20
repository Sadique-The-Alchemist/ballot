defmodule Ballot.Poll.Candidate do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:name, :symbol, :vote_id]

  @optional_fields [:image_url, :pole_count]

  schema "candidates" do
    field :name, :string
    field :symbol, :string
    field :image_url, :string
    field :pole_count, :integer
    belongs_to :vote, Ballot.Poll.Vote
    timestamps()
  end

  def changeset(candidate, params \\ %{}) do
    candidate
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
