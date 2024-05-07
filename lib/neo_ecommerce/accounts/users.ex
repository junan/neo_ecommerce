defmodule NeoEcommerce.Accounts.Users do
  alias NeoEcommerce.Repo
  alias NeoEcommerce.Auth.Hasher
  alias NeoEcommerce.Accounts.Schemas.{User, Role}

  def create(attrs) do
    attrs
    |> User.create_changeset()
    |> Repo.insert()
  end

  def authenticate_user(%User{password_hash: password_hash} = user, password) do
    if Hasher.verify_secret(password, password_hash, :argon2) do
      {:ok, user}
    else
      {:error, :invalid_password}
    end
  end

  def assign_role(%User{} = user, %Role{} = role) do
    preloaded_user = Repo.preload(user, :roles)

    preloaded_user
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:roles, preloaded_user.roles ++ [role])
    |> Repo.update()
  end
end
