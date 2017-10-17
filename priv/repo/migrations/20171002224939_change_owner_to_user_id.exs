defmodule Microblog.Repo.Migrations.ChangeOwnerToUserId do
  use Ecto.Migration
  
  def up do
  	alter table(:messages) do
  		remove :owner
  		add :user_id, :id
  	end
  end

  def down do
  	alter table(:messages) do
  		remove :user_id
  		add :owner, :id
  	end
  end

  def change do
		alter table(:messages) do
  		remove :owner
  		add :user_id, :id
  	end
  end
end
