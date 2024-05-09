defmodule NeoEcommerce.Products.Schemas.Category do
  use Ecto.Schema

  import Ecto.Changeset

  schema "categories" do
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(category \\ %__MODULE__{}, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
