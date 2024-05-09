defmodule NeoEcommerce.Products.ProductsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `NeoEcommerce.Products.Products` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        description: "some description",
        inventory_count: 42,
        name: "some name",
        price: "120.5"
      })
      |> NeoEcommerce.Products.Products.create()

    product
  end
end
