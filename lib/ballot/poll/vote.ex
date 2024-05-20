defmodule Ballot.Poll.Vote do
  use Ecto.Schema
  import Ecto.Changeset
  @required_fields [:name, :type]
  @optional_fields [:totlal_voters, :polling_count]

  schema "votes" do
    field :name, :string
    field :type, Ecto.Enum, values: [:anonymous, :with_identity]
    field :total_voters, :integer
    field :polling_count, :integer
    has_many(:candidate, Ballot.Poll.Candidate)
    timestamps()
  end

  def changeset(vote, params \\ %{}) do
    vote
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
