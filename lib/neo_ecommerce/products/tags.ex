defmodule NeoEcommerce.Products.Tags do
  alias NeoEcommerce.Repo
  alias NeoEcommerce.Products.Schemas.Tag

  def create(attrs) do
    attrs
    |> Tag.create_changeset()
    |> Repo.insert()
  end
end
