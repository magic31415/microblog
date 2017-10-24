defmodule MicroblogWeb.PageController do
  use MicroblogWeb, :controller

  def index(conn, _params) do
  	user = MicroblogWeb.Plugs.fetch_user(conn, _params).assigns.current_user
  	if user do
  		redirect conn, to: message_path(conn, :index)
  	else
  		render(conn, "index.html")
  	end
  end
end
