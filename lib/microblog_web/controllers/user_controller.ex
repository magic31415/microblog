defmodule MicroblogWeb.UserController do
  use MicroblogWeb, :controller

  alias Microblog.Social
  alias Microblog.Social.User

  def set_current_user(conn, _params) do
    MicroblogWeb.Plugs.fetch_user(conn, _params).assigns.current_user
  end

  def not_logged_in(conn) do
    conn
    |> redirect(to: page_path(conn, :index))
  end

  # TODO move to social.ex
  def allowed_to_follow(follower, followee) do
    follower != nil
      && follower.id != followee.id
      && !Social.get_follow_by_ids(follower.id, followee.id)
  end

  def index(conn, _params) do
    current_user = set_current_user(conn, _params)
    if current_user do
      users = Social.list_users()
      render(conn, "index.html", users: users)
    else
      not_logged_in(conn)
    end
  end

  def new(conn, _params) do
    changeset = Social.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Social.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully. Now logged in as #{user.name}.")
        |> put_session(:user_id, user.id)
        |> redirect(to: message_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    current_user = set_current_user(conn, %{"id" => id})
    if current_user do
      user = Social.get_user!(id)
      current_user_id = conn.assigns[:user_id]
      follow = Social.change_follow(%Microblog.Social.Follow{follower_id: current_user_id,
                                                             followee_id: id})
      follows = Social.list_follows()
      followable = allowed_to_follow(current_user, user)
      render(conn, "show.html", user: user,
                                follow: follow,
                                follows: follows,
                                current_user_id: current_user_id,
                                followable: followable)
    else
      not_logged_in(conn)
    end
  end

  def edit(conn, %{"id" => id}) do
    current_user = set_current_user(conn, %{"id" => id})
    user = Social.get_user!(id)

    if current_user != nil && current_user.id == user.id do
      changeset = Social.change_user(user)
      render(conn, "edit.html", user: user, changeset: changeset)
    else
      not_logged_in(conn)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    current_user = set_current_user(conn, %{"id" => id, "user" => user_params})
    user = Social.get_user!(id)

    if current_user != nil && current_user.id == user.id do
      case Social.update_user(user, user_params) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "User updated successfully.")
          |> redirect(to: user_path(conn, :show, user))
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", user: user, changeset: changeset)
      end
    else
      not_logged_in(conn)
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = set_current_user(conn, %{"id" => id})
    user = Social.get_user!(id)

    if current_user != nil && current_user.id == user.id do
      {:ok, _user} = Social.delete_user(user)

      conn
      |> put_flash(:info, "User deleted successfully. Logged out.")
      |> put_session(:user_id, nil)
      |> redirect(to: user_path(conn, :index))
    else
      not_logged_in(conn)
    end
  end
end
