defmodule Ballot.Repo.Migrations.CreateVotes do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add :name, :string
      add :type, :string
      add :total_voters, :integer
      add :polling_count, :integer
      timestamps()
    end
    create table(:candidates) do
    add :name, :string
    add :symbol, :string
    add :image_url, :string
    add :poll_count, :integer, default: 0
    add :vote_id, references(:votes)
    timestamps()
    end
  end
end
