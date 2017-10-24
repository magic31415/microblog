defmodule Microblog.Social.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Microblog.Social.User
  alias Microblog.Social


  schema "users" do
    field :email, :string
    field :name, :string
    has_many :messages, Microblog.Social.Message
    has_many :followers, Microblog.Social.Follow, foreign_key: :follower_id
    has_many :followees, Microblog.Social.Follow, foreign_key: :followee_id

    # From class notes
    field :password_hash, :string
    field :pw_tries, :integer
    field :pw_last_try, :utc_datetime

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :password_confirmation])
    |> validate_confirmation(:password)
    |> validate_password(:password)
    |> put_pass_hash()
    |> validate_required([:name, :email, :password_hash])
  end

  # Password validation
  # From Comeonin docs and lecture notes
  def validate_password(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, password ->
      case valid_password?(password) do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || msg}]
      end
    end)
  end

  def put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Comeonin.Argon2.add_hash(password))
  end
  def put_pass_hash(changeset), do: changeset

  def valid_password?(password) when byte_size(password) > 7 do
    {:ok, password}
  end
  def valid_password?(_), do: {:error, "The password is too short"}

  # From lecture notes
  def get_and_auth_user(email, password) do
    user = Social.get_user_by_email(email)
    case user != nil && throttle_attempts(user) && Comeonin.Argon2.check_pass(user, password) do
      {:ok, user} -> user
      _else       -> nil
    end
  end

  # From lecture notes
  def update_tries(throttle, prev) do
    if throttle do
      prev + 1
    else
      1
    end
  end

  def throttle_attempts(user) do
    y2k = DateTime.from_naive!(~N[2000-01-01 00:00:00], "Etc/UTC")
    prv = DateTime.to_unix(user.pw_last_try || y2k)
    now = DateTime.to_unix(DateTime.utc_now())
    thr = (now - prv) < 3600

    if (thr && user.pw_tries > 5) do
      nil
    else
      changes = %{
          pw_tries: update_tries(thr, user.pw_tries),
          pw_last_try: DateTime.utc_now(),
      }
      IO.inspect(user)
      {:ok, user} = Ecto.Changeset.cast(user, changes, [:pw_tries, :pw_last_try])
      |> Microblog.Repo.update
      user
    end
  end
end
