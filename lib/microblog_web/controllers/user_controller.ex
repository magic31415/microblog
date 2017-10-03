defmodule MicroblogWeb.UserController do
  use MicroblogWeb, :controller

  alias Microblog.Social
  alias Microblog.Social.User

  def index(conn, _params) do
    users = Social.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Social.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Social.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Social.get_user!(id)
    current_user_id = conn.assigns[:user_id]
    follow = Social.change_follow(%Microblog.Social.Follow{follower_id: current_user_id, followee_id: id})

    follows = Social.list_follows()
    render(conn, "show.html", user: user, follow: follow, follows: follows, current_user_id: current_user_id)
  end

  def edit(conn, %{"id" => id}) do
    user = Social.get_user!(id)
    changeset = Social.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Social.get_user!(id)

    case Social.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Social.get_user!(id)
    {:ok, _user} = Social.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end
end
