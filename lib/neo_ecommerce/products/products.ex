defmodule NeoEcommerce.Products.Products do
  @moduledoc false

  import Ecto.Query, warn: false

  alias NeoEcommerce.Repo
  alias NeoEcommerce.Products.Schemas.Product

  use Torch.Pagination,
    repo: NeoEcommerce.Repo,
    model: NeoEcommerce.Products.Schemas.Product,
    name: :products

  @doc """
  Creates a product by passing a map of attributes.
  """
  @spec create_product(map()) :: {:ok, Product.t()} | {:error, Ecto.Changeset.t()}
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
  @spec list_products() :: [Product.t()]
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
  @spec get_product!(integer()) :: Product.t()
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
  @spec update_product(Product.t(), map()) :: {:ok, Product.t()} | {:error, Ecto.Changeset.t()}
  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, updated_product} ->
        updated_product = Repo.preload(updated_product, :category)
        notify({:ok, updated_product}, :product_updated)

      error ->
        error
    end
  end

  @doc """
  Deletes a Product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_product(Product.t()) :: {:ok, Product.t()} | {:error, Ecto.Changeset.t()}
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
  @spec change_product(Product.t(), map()) :: Ecto.Changeset.t()
  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end

  defp notify({:ok, %Product{} = product}, event) do
    Phoenix.PubSub.broadcast(NeoEcommerce.PubSub, "products:all", {event, product})

    {:ok, product}
  end

  defp notify({:error, _changeset} = error, _event), do: error
end
