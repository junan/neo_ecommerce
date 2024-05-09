defmodule NeoEcommerce.Products.Categories do
  alias NeoEcommerce.Repo
  alias NeoEcommerce.Products.Schemas.Category

  import Ecto.Query, warn: false

  def list_product_categories_by_name_and_id,
    do: Repo.all(from(c in Category, select: {c.name, c.id}))

  def create(attrs) do
    attrs
    |> Category.create_changeset()
    |> Repo.insert()
  end
end
