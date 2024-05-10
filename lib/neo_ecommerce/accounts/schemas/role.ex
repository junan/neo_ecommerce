defmodule NeoEcommerce.Accounts.Schemas.Role do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias NeoEcommerce.Accounts.Schemas.User

  schema "roles" do
    field :name, :string
    many_to_many :users, User, join_through: "users_roles"

    timestamps(type: :utc_datetime)
  end

  @doc """
  Creates a changeset based on the `role` and `attrs`. It will downcase the role name(to avoid case sensitivity issues like `Admin` and `admin`)
  """
  @spec create_changeset(Role.t(), map()) :: Ecto.Changeset.t()
  def create_changeset(role \\ %__MODULE__{}, attrs) do
    role
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> downcase_role_name()
  end

  defp downcase_role_name(%Ecto.Changeset{changes: %{name: name}, valid?: true} = changeset) do
    put_change(changeset, :name, String.downcase(name))
  end
end
