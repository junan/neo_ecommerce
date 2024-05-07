defmodule NeoEcommerce.Products.Products do
  alias NeoEcommerce.Repo
  alias NeoEcommerce.Products.Schemas.{Product, Tag}

  def create(attrs) do
    attrs
    |> Product.create_changeset()
    |> Repo.insert()
  end

  def assign_tag(%Product{} = product, %Tag{} = tag) do
    preloaded_product = Repo.preload(product, :tags)

    preloaded_product
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:tags, preloaded_product.tags ++ [tag])
    |> Repo.update()
  end
end
