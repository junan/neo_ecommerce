defmodule NeoEcommerce.Products.Categories do
  @moduledoc false

  import Ecto.Query, warn: false

  alias NeoEcommerce.Repo
  alias NeoEcommerce.Products.Schemas.Category

  use Torch.Pagination,
    repo: NeoEcommerce.Repo,
    model: NeoEcommerce.Products.Schemas.Category,
    name: :categories

  @doc """
  Returns the list of product categories by name and id.
  """
  @spec list_product_categories_by_name_and_id() :: [{:name, :id}]
  def list_product_categories_by_name_and_id,
    do: Repo.all(from(c in Category, select: {c.name, c.id}))

  @doc """
  Creates a category by passing a map of attributes.
  """
  def create(attrs) do
    attrs
    |> Category.changeset()
    |> Repo.insert()
  end

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  @spec list_categories() :: [Category.t()]
  def list_categories do
    Repo.all(Category)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_category!(integer()) :: Category.t()
  def get_category!(id), do: Repo.get!(Category, id)

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_category(map()) :: {:ok, Category.t()} | {:error, Ecto.Changeset.t()}
  def create_category(attrs \\ %{}) do
    attrs
    |> Category.changeset()
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_category(Category.t(), map()) :: {:ok, Category.t()} | {:error, Ecto.Changeset.t()}
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_category(Category.t()) :: {:ok, Category.t()} | {:error, Ecto.Changeset.t()}
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{source: %Category{}}

  """
  @spec change_category(Category.t(), map()) :: Ecto.Changeset.t()
  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end
end
