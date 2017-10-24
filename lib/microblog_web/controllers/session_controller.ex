#
# Session Controller from
# https://github.com/NatTuck/nu_mart
#

defmodule MicroblogWeb.SessionController do
  use MicroblogWeb, :controller

  def login(conn, %{"email" => email, "password" => password}) do
    user = Microblog.Social.User.get_and_auth_user(email, password)

    if user do
      conn
      |> put_session(:user_id, user.id)
      |> put_flash(:info, "Logged in as #{user.name}")
      |> redirect(to: message_path(conn, :index))
    else
      conn
      |> put_session(:user_id, nil)
      |> put_flash(:error, "Bad email and password combination.")
      |> redirect(to: message_path(conn, :index))
    end
  end

  def logout(conn, _args) do
    conn
    |> put_session(:user_id, nil)
    |> put_flash(:info, "Logged out.")
    |> redirect(to: page_path(conn, :index))
  end
end