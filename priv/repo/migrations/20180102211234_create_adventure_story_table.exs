defmodule Adventure.Repo.Migrations.CreateAdventureStoryTable do
  use Ecto.Migration

  def up do
    create table(:story) do
      add :search_request, :string, null: false
      add :source_text, :text
      add :terms, {:array, :string}, default: []

      timestamps()
    end
  end

  def down do
    drop table(:story)
  end
end
