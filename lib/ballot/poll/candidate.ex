defmodule Ballot.Poll.Candidate do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:name, :symbol, :vote_id, :color]

  @optional_fields [:image_url, :pole_count]

  defimpl Jason.Encoder, for: Ballot.Poll.Candidate  do
    @impl Jason.Encoder
    def encode(value, opts) do
      Jason.Encode.map(%{name: value.name, symbol: value.symbol, poll_count: value.poll_count, color: value.color, pid: ""},opts)
    end
  end

  schema "candidates" do
    field :name, :string
    field :symbol, :string
    field :image_url, :string
    field :poll_count, :integer
    field :color, :string
    belongs_to :vote, Ballot.Poll.Vote
    timestamps()
  end

  def changeset(candidate, params \\ %{}) do
    candidate
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
