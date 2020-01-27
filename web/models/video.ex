defmodule ApiVideo.Video do
  use ApiVideo.Web, :model
  use Ecto.Schema

  @primary_key {:id, :string, []}
  schema "videos" do
    field :status, :string
    field :asset_id, :string
    field :url, :string
    field :test, :boolean
    field :timeout, :integer
    field :created_at, :naive_datetime
    field :mp4_support, :string
    field :master_access, :string

    has_many :playback_ids, ApiVideo.PlaybackID
  end

  def changeset(video, params) do
   video
    |> cast(params, [:id, :created_at, :url, :status, :mp4_support, :master_access, :test])
    |> validate_required([:id])
  end

end
