defmodule ApiVideo.Repo.Migrations.CreateVideos do
  use Ecto.Migration

  def change do
    create table(:videos, primary_key: false) do
      add :id, :string, primary_key: true
      add :status, :string
      add :url, :text
      add :test, :boolean
      add :timeout, :bigint
      add :created_at, :integer
      add :mp4_support, :string
      add :master_access, :string
    end

    create unique_index(:videos, [:id])

    create table(:playback_ids, primary_key: false) do
      add :playback_id, :string, primary_key: true
      add :video_id, references(:videos, type: :string)
      add :policy, :string
    end
  end
end
