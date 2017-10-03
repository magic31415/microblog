defmodule Microblog.Social.Follow do
  use Ecto.Schema
  import Ecto.Changeset
  alias Microblog.Social.Follow


  schema "follows" do
    belongs_to :follower, Microblog.Social.User
    belongs_to :followee, Microblog.Social.User

    timestamps()
  end

  @doc false
  def changeset(%Follow{} = follow, attrs) do
    follow
    |> cast(attrs, [:follower_id, :followee_id])
    |> validate_required([:follower_id, :followee_id])
  end
end
