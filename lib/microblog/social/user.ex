defmodule Microblog.Social.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Microblog.Social.User


  schema "users" do
    field :email, :string
    field :name, :string
    has_many :messages, Microblog.Social.Message
    has_many :followers, Microblog.Social.Follow, foreign_key: :follower_id
    has_many :followees, Microblog.Social.Follow, foreign_key: :followee_id

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
  end
end
