defmodule ApiVideo.VideoController do
  use ApiVideo.Web, :controller
  alias ApiVideo.Video
  alias ApiVideo.PlaybackID

  def action(conn, _) do
    mux_client = Mux.client()
    args = [conn, conn.params, mux_client]
    apply(__MODULE__, action_name(conn), args)
  end

  @spec index(Plug.Conn.t(), any, Tesla.Client.t()) :: Plug.Conn.t()
  def index(conn, _params, mux_client) do
    case Mux.Video.Uploads.list(mux_client) do
      {:ok, videos, _} ->
        uploaded = Enum.filter(videos, &is_uploaded?/1)
        render(conn, "index.json", videos: uploaded)
      {:error, message, _} -> render(conn, "404.json", %{message: message})
    end
  end

  defp is_uploaded?(%{"status" => "asset_created"}), do: true
  defp is_uploaded?(_), do: false

  @spec create(Plug.Conn.t(), map, Tesla.Client.t()) :: Plug.Conn.t()
  def create(conn, %{"video" => custom_params} \\ %{}, mux_client) do

    params = Map.merge(%{"new_asset_settings" => %{"playback_policy" => "public"}}, custom_params)

    case Mux.Video.Uploads.create(mux_client, params) do
      {:ok, asset, _} ->
        changeset = Video.changeset(%Video{}, asset)
        {:ok, video} = Repo.insert(changeset)
        render(conn, "create.json", video: video)
      {:error, message, _} ->
        render(conn, "404.json", %{message: message})
    end
  end

  @spec show(Plug.Conn.t(), map, Tesla.Client.t()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}, mux_client) do

    with {:ok, videos, _} <- Mux.Video.Uploads.list(mux_client),
      {:ok, video} <- get_video(videos, id),
      {:ok, asset_id} <- get_asset_id(video)
      do
        playback_id =
          with {:ok, %{"playback_ids" => playback_ids}, _} <- Mux.Video.Assets.get(mux_client, asset_id),
            %{"id" => playback_id, "policy" => "public"} <- Enum.find(playback_ids, fn map -> map["policy"] == "public" end) do
            playback_id
            else
              {} ->
                {:ok, playback_id, _env} = Mux.Video.PlaybackIds.create(mux_client, asset_id, %{policy: "public"})
                playback_id
            end
        url = "stream.mux.com/" <> playback_id
        render(conn, "show.json", %{video_url: url})
      else
        {:error, message} ->
          render(conn, "404.json", %{message: message})
      end
    end


  defp get_video(videos, id) do
    case Enum.find(videos, fn map -> map["id"] == id end) do
      video when video != nil -> {:ok, video}
      _ -> {:error, "No video with this ID"}
    end
  end

  defp get_asset_id(video) do
    IO.inspect(video)
    IO.inspect(video["asset_id"])
   case video["asset_id"] do
     asset_id when asset_id != nil -> {:ok, asset_id}
     _ -> {:error, "Video not uploaded yet"}
   end
  end
end
