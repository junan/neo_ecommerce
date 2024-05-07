defmodule NeoEcommerce.Accounts.Roles do
  alias NeoEcommerce.Repo
  alias NeoEcommerce.Accounts.Schemas.Role

  def create(attrs) do
    attrs
    |> Role.create_changeset()
    |> Repo.insert()
  end
end
