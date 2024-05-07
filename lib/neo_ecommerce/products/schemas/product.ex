defmodule NeoEcommerce.Products.Schemas.Product do
  use Ecto.Schema

  import Ecto.Changeset

  alias NeoEcommerce.Products.Schemas.Tag

  schema "products" do
    field :name, :string
    field :description, :string
    field :inventory_count, :integer
    field :price, :decimal
    field :category_id, :id

    many_to_many :tags, Tag, join_through: "products_tags"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def create_changeset(product \\ %__MODULE__{}, attrs) do
    product
    |> cast(attrs, [:name, :description, :price, :inventory_count, :category_id])
    |> validate_required([:name, :description, :price, :inventory_count, :category_id])
    |> validate_number(:price, greater_than: 0)
    |> validate_number(:inventory_count, greater_than_or_equal_to: 0)
    |> unique_constraint(:name, name: :unique_product_name_category_id)
    |> foreign_key_constraint(:category_id)
  end
end
