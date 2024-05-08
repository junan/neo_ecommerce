defmodule NeoEcommerce.Accounts.Users do
  alias NeoEcommerce.Repo
  alias NeoEcommerce.Accounts.Schemas.{User, Role}

  def get_user_by_id(id), do: Repo.get(User, id)

  def get_user_by_email(email), do: Repo.get_by(User, %{email: email})

  def create(attrs) do
    attrs
    |> User.create_changeset()
    |> Repo.insert()
  end

  def assign_role(%User{} = user, %Role{} = role) do
    preloaded_user = Repo.preload(user, :roles)

    preloaded_user
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:roles, preloaded_user.roles ++ [role])
    |> Repo.update()
  end
end
