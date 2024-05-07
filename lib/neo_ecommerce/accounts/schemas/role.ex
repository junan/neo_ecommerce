defmodule NeoEcommerce.Accounts.Schemas.Role do
  use Ecto.Schema

  import Ecto.Changeset

  alias NeoEcommerce.Accounts.Schemas.User

  schema "roles" do
    field :name, :string
    many_to_many :users, User, join_through: "users_roles"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def create_changeset(role \\ %__MODULE__{}, attrs) do
    role
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
