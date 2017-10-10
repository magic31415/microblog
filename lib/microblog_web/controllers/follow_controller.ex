defmodule MicroblogWeb.FollowController do
  use MicroblogWeb, :controller

  alias Microblog.Social
  alias Microblog.Social.Follow

  def index(conn, _params) do
    follows = Social.list_follows()
    render(conn, "index.html", follows: follows)
  end

  def new(conn, _params) do
    changeset = Social.change_follow(%Follow{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"follow" => follow_params}) do
    case Social.create_follow(follow_params) do
      {:ok, follow} ->
        follow = Microblog.Repo.preload(follow, :followee)
        conn
        |> put_flash(:info, "You are now following #{follow.followee.name}.")
        |> redirect(to: user_path(conn, :show, follow.followee))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    follow = Social.get_follow!(id)
    render(conn, "show.html", follow: follow)
  end

  def edit(conn, %{"id" => id}) do
    follow = Social.get_follow!(id)
    changeset = Social.change_follow(follow)
    render(conn, "edit.html", follow: follow, changeset: changeset)
  end

  def update(conn, %{"id" => id, "follow" => follow_params}) do
    follow = Social.get_follow!(id)

    case Social.update_follow(follow, follow_params) do
      {:ok, follow} ->
        conn
        |> put_flash(:info, "Follow updated successfully.")
        |> redirect(to: follow_path(conn, :show, follow))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", follow: follow, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    follow = Social.get_follow!(id)
    {:ok, _follow} = Social.delete_follow(follow)
    follow = Microblog.Repo.preload(follow, :followee)
    conn
    |> put_flash(:info, "You are no longer following #{follow.followee.name}.")
    |> redirect(to: NavigationHistory.last_path(conn, default: user_path(conn, :index)))
  end
end
