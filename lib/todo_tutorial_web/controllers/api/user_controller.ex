defmodule TodoTutorialWeb.Api.UserController do
  use TodoTutorialWeb, :controller

  alias TodoTutorial.Accounts
  alias TodoTutorial.Accounts.User

  action_fallback TodoTutorialWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, %User{} = user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.api_user_path(conn, :show, user))
        |> render("show.json", user: user)

      {:error, _} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(TodoTutorialWeb.Api.ErrorView)
        |> render("422.json", %{message: "some params can't be blank"})
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, %User{} = user} ->
        render(conn, "show.json", user: user)

      {:error, _} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(TodoTutorialWeb.Api.ErrorView)
        |> render("422.json", %{message: "some params can't be blank"})
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
