defmodule Microblog.Repo.Migrations.ChangeOwnerToUserId do
  use Ecto.Migration

  def change do
		alter table(:messages) do
  		remove :owner
  		add :user_id, :id
  	end
  end
end
