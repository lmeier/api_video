defmodule ApiVideo.PageController do
  use ApiVideo.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
