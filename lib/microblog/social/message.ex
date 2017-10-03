defmodule Microblog.Social.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias Microblog.Social.Message


  schema "messages" do
    field :content, :string
    belongs_to :user, Microblog.Social.User

    timestamps()
  end

  @doc false
  def changeset(%Message{} = message, attrs) do
    message
    |> cast(attrs, [:content, :user_id])
    |> validate_required([:content, :user_id])
  end
end
