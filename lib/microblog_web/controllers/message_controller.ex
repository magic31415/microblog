defmodule MicroblogWeb.MessageController do
  use MicroblogWeb, :controller

  alias Microblog.Social
  alias Microblog.Social.Message

  def set_current_user(conn, _params) do
    MicroblogWeb.Plugs.fetch_user(conn, _params).assigns.current_user
  end

  def not_logged_in(conn) do
    conn
    |> redirect(to: page_path(conn, :index))
  end

  def index(conn, _params) do
    current_user = set_current_user(conn, _params)
    if current_user do
      messages = Social.list_messages()
      likes = Social.list_likes()
      changeset = Social.change_message(%Message{})
      render(conn, "index.html", messages: messages, likes: likes, changeset: changeset)
    else
      not_logged_in(conn)
    end
  end

  def new(conn, _params) do
    current_user = set_current_user(conn, _params)
    if current_user do
      changeset = Social.change_message(%Message{})
      conn
      |> redirect(to: message_path(conn, :index))
    else
      not_logged_in(conn)
    end
  end

  def create(conn, %{"message" => message_params}) do
    current_user = set_current_user(conn, %{"message" => message_params})
    if current_user do
      case Social.create_message(message_params) do
        {:ok, message} ->
          message_with_name =  %{id: message.id,
                                 user_id: message.user_id,
                                 content: message.content,
                                 user_name: Social.get_user!(message.user_id).name}
          MicroblogWeb.Endpoint.broadcast("updates:all", "message", message_with_name)
          conn
          |> put_flash(:info, "Message created successfully.")
          |> redirect(to: message_path(conn, :index))
        {:error, %Ecto.Changeset{} = changeset} ->
          conn
          |> redirect(to: message_path(conn, :index))
        end
    else
      not_logged_in(conn)
    end
  end

  def show(conn, %{"id" => id}) do
    current_user = set_current_user(conn, %{"id" => id})
    if current_user do
      message = Social.get_message!(id)
      owner = Social.get_user!(Social.get_message!(id).user_id)
      render(conn, "show.html", message: message, owner: owner)
    else
      not_logged_in(conn)
    end
  end

  def edit(conn, %{"id" => id}) do
    current_user = set_current_user(conn, %{"id" => id})
    message = Social.get_message!(id)

    if current_user != nil && message.user_id == current_user.id do
      changeset = Social.change_message(message)
      render(conn, "edit.html", message: message, changeset: changeset)
    else
      not_logged_in(conn)
    end
  end

  def update(conn, %{"id" => id, "message" => message_params}) do
    current_user = set_current_user(conn, %{"id" => id, "message" => message_params})
    message = Social.get_message!(id)

    if current_user != nil && message.user_id == current_user.id do
      case Social.update_message(message, message_params) do
        {:ok, message} ->
          conn
          |> put_flash(:info, "Message updated successfully.")
          |> redirect(to: message_path(conn, :show, message))
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", message: message, changeset: changeset)
      end
    else
      not_logged_in(conn)
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = set_current_user(conn, %{"id" => id})
    message = Social.get_message!(id)

    if current_user != nil && message.id == current_user.id do
      {:ok, _message} = Social.delete_message(message)

      conn
      |> put_flash(:info, "Message deleted successfully.")
      |> redirect(to: message_path(conn, :index))
    else
      not_logged_in(conn)
    end
  end
end
