defmodule Ballot.Repo.Migrations.AddColor do
  use Ecto.Migration

  def change do
   alter table(:candidates) do
    add :color, :string
   end
  end
end
