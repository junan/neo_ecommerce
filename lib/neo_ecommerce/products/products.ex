defmodule NeoEcommerce.Products.Products do
  import Ecto.Query, warn: false

  alias NeoEcommerce.Repo
  alias NeoEcommerce.Products.Schemas.Product

  use Torch.Pagination,
    repo: NeoEcommerce.Repo,
    model: NeoEcommerce.Products.Schemas.Product,
    name: :products

  def create_product(attrs) do
    attrs
    |> Product.changeset()
    |> Repo.insert()
    |> notify(:product_created)
  end

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    query =
      from p in Product,
        order_by: [desc: p.inserted_at],
        preload: [:category]

    Repo.all(query)
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id) do
    Repo.get!(Product, id) |> Repo.preload(:category)
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
    |> notify(:product_updated)
  end

  @doc """
  Deletes a Product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    product
    |> Repo.delete()
    |> notify(:product_deleted)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{source: %Product{}}

  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end

  defp notify({:ok, %Product{} = product}, event) do
    Phoenix.PubSub.broadcast(NeoEcommerce.PubSub, "products:all", {event, product})

    {:ok, product}
  end

  defp notify({:error, _changeset} = error, _event), do: error
end
