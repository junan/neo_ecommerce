defmodule NeoEcommerce.Repo.Migrations.CreateUsersRoles do
  use Ecto.Migration

  def change do
    create table(:users_roles, primary_key: false) do
      add :user_id, references(:users), null: false
      add :role_id, references(:roles), null: false
    end

    create unique_index(:users_roles, [:user_id, :role_id])
  end
end
