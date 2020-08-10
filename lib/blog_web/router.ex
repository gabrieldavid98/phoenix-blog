defmodule BlogWeb.Router do
  use BlogWeb, :router
  use Pow.Phoenix.Router

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

  pipeline :protected do
    plug :browser
    plug Pow.Plug.RequireAuthenticated, 
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
  end

  scope "/", BlogWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/", BlogWeb do
    pipe_through :protected

    resources "/posts", PostController do
      post "/comment", PostController, :add_comment, as: :comment
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", BlogWeb do
  #   pipe_through :api
  # end
end
