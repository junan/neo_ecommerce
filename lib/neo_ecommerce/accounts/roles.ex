defmodule NeoEcommerce.Accounts.Roles do
  @moduledoc false

  alias NeoEcommerce.Repo
  alias NeoEcommerce.Accounts.Schemas.Role

  @doc """
  Creates a role by passing a map of attributes.
  """
  @spec create(map()) :: {:ok, Role.t()} | {:error, Ecto.Changeset.t()}
  def create(attrs) do
    attrs
    |> Role.create_changeset()
    |> Repo.insert()
  end
end
