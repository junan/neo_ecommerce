defmodule NeoEcommerce.Accounts.Users do
  @moduledoc false

  alias NeoEcommerce.Repo
  alias NeoEcommerce.Accounts.Schemas.User

  @doc """
   Find a user from database by its id.
  """
  @spec get_user_by_id(integer()) :: User.t() | nil
  def get_user_by_id(id), do: Repo.get(User, id)

  @doc """
    Find a user from database by its email.
  """
  @spec get_user_by_email(String.t()) :: User.t() | nil
  def get_user_by_email(email), do: Repo.get_by(User, %{email: email})

  @doc """
    Creates a user by passing a map of attributes.
  """
  @spec create(map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create(attrs) do
    attrs
    |> User.create_changeset()
    |> Repo.insert()
  end
end
