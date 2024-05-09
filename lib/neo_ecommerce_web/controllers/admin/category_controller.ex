defmodule NeoEcommerceWeb.Admin.CategoryController do
  use NeoEcommerceWeb, :controller

  alias NeoEcommerce.Products.Categories
  alias NeoEcommerce.Products.Schemas.Category

  plug(:put_root_layout, {NeoEcommerceWeb.Layouts, "torch.html"})
  plug(:put_layout, false)

  def index(conn, params) do
    case Categories.paginate_categories(params) do
      {:ok, assigns} ->
        render(conn, :index, assigns)

      {:error, error} ->
        conn
        |> put_flash(:error, "There was an error rendering Categories. #{inspect(error)}")
        |> redirect(to: ~p"/admin/categories")
    end
  end

  def new(conn, _params) do
    changeset = Categories.change_category(%Category{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"category" => category_params}) do
    case Categories.create_category(category_params) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "Category created successfully.")
        |> redirect(to: ~p"/admin/categories/#{category}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    category = Categories.get_category!(id)
    render(conn, :show, category: category)
  end

  def edit(conn, %{"id" => id}) do
    category = Categories.get_category!(id)
    changeset = Categories.change_category(category)
    render(conn, :edit, category: category, changeset: changeset)
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = Categories.get_category!(id)

    case Categories.update_category(category, category_params) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "Category updated successfully.")
        |> redirect(to: ~p"/admin/categories/#{category}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, category: category, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = Categories.get_category!(id)
    {:ok, _category} = Categories.delete_category(category)

    conn
    |> put_flash(:info, "Category deleted successfully.")
    |> redirect(to: ~p"/admin/categories")
  end
end
