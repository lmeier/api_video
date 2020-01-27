defmodule ApiVideo.VideoView do
  use ApiVideo.Web, :view

  def render("index.json", %{videos: videos}) do
    %{
      videos: Enum.map(videos, &upload_json/1)
    }
  end

  def render("show.json", %{video_url: video_url}) do
    %{video_url: video_url}
  end

  def render("create.json", %{video: video}) do
    %{video: created_json(video)}
  end

  def render("404.json", %{message: message}) do
    %{error: message}
  end

  def upload_json(upload) do
    %{
      id: upload["id"],
      status: upload["status"]
    }
  end

  def created_json(video) do
    %{
      url: video.url,
    }
  end

  def video_json(video) do
    %{
      id: video.id,
      status: video.status,
      url: video.url,
      test: video.test,
    }
  end
end
