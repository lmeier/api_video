defmodule ApiVideo.VideoControllerTest do
  use ExUnit.Case, async: false
  use ApiVideo.ConnCase
  # use Plug.Test
  alias ApiVideo.Repo
  alias Ecto.Adapters.SQL

  test "/api/videos returns uploaded videos" do
    conn = get(build_conn(), "/")
    response = conn(:get, "/api/videos") |> send_request
    assert response.status == 200
  end

  test "/api/videos:id returns streaming url of uploaded video" do
    conn = get(build_conn(), "/")
    response = conn(:get, "/api/videos/" <> "Q9VEIpQDnyQh2worJsJmvOOimFkb02f2f") |> send_request
    assert response.status == 200
  end

  defp send_request(conn) do
    conn
    |> put_private(:plug_skip_csrf_protection, true)
    |> ApiVideo.Endpoint.call([])
  end
end
