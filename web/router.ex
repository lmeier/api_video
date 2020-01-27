defmodule ApiVideo.Router do
  use ApiVideo.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ApiVideo do
    pipe_through :api

    # get "/videos", VideoController, :index
    resources "/videos", VideoController, only: [:index, :create, :show]

  end
end
