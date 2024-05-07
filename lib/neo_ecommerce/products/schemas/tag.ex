defmodule NeoEcommerce.Products.Schemas.Tag do
  use Ecto.Schema

  import Ecto.Changeset

  alias NeoEcommerce.Products.Schemas.Product

  schema "tags" do
    field :name, :string

    many_to_many :tags, Product, join_through: "products_tags"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def create_changeset(tag \\ %__MODULE__{}, attrs) do
    tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
