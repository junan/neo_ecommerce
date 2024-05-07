defmodule NeoEcommerce.Products.Categories do
  alias NeoEcommerce.Repo
  alias NeoEcommerce.Products.Schemas.Category

  def create(attrs) do
    attrs
    |> Category.create_changeset()
    |> Repo.insert()
  end
end
