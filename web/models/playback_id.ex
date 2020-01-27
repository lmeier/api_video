defmodule ApiVideo.PlaybackID do
  use ApiVideo.Web, :model
  use Ecto.Schema

  schema "playback_ids" do
    field :playback_id, :string
    field :policy, :string
    belongs_to :video_id, ApiVideo.Video
  end

  def changeset(playback_id, params) do
    playback_id
     |> cast(params, [:playback_id, :policy, :video_id])
     |> validate_required([:playback_id, :policy, :video_id])
   end
end
