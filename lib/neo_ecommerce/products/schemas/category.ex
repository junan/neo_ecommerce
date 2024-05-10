defmodule NeoEcommerce.Products.Schemas.Category do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  schema "categories" do
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc """
  Creates a changeset based on the `category` and `attrs`.
  """
  @spec changeset(Category.t(), map()) :: Ecto.Changeset.t()
  def changeset(category \\ %__MODULE__{}, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
