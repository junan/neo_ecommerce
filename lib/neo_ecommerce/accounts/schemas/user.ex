defmodule NeoEcommerce.Accounts.Schemas.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias NeoEcommerce.Accounts.Schemas.Role
  alias NeoEcommerce.Auth.Hasher

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password_hash, :string

    # Virtual attribute to hold the password
    field :password, :string, virtual: true, redact: true

    many_to_many :roles, Role, join_through: "users_roles"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def create_changeset(user \\ %__MODULE__{}, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :password])
    |> validate_required([:first_name, :last_name, :email, :password])
    |> unique_constraint(:email)
    # TODO: validate email format and password
    |> maybe_hash_password()
  end

  defp maybe_hash_password(
         %Ecto.Changeset{changes: %{password: password}, valid?: true} = changeset
       )
       when is_binary(password) do
    put_change(changeset, :password_hash, Hasher.hash_secret(password, :argon2))
  end

  defp maybe_hash_password(changeset), do: changeset
end
