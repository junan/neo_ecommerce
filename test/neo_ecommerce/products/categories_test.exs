defmodule NeoEcommerce.Products.CategoriesTest do
  use NeoEcommerce.DataCase

  alias NeoEcommerce.Products.Categories

  alias NeoEcommerce.Products.Schemas.Category

  @valid_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  describe "#paginate_categories/1" do
    test "returns paginated list of categories" do
      for _ <- 1..20 do
        category_fixture()
      end

      {:ok, %{categories: categories} = page} = Categories.paginate_categories(%{})

      assert length(categories) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end
  end

  describe "#list_categories/0" do
    test "returns all categories" do
      category = category_fixture()
      assert Categories.list_categories() == [category]
    end
  end

  describe "#get_category!/1" do
    test "returns the category with given id" do
      category = category_fixture()
      assert Categories.get_category!(category.id) == category
    end
  end

  describe "#create_category/1" do
    test "with valid data creates a category" do
      assert {:ok, %Category{} = category} = Categories.create_category(@valid_attrs)
      assert category.name == "some name"
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Categories.create_category(@invalid_attrs)
    end
  end

  describe "#update_category/2" do
    test "with valid data updates the category" do
      category = category_fixture()
      assert {:ok, category} = Categories.update_category(category, @update_attrs)
      assert %Category{} = category
      assert category.name == "some updated name"
    end

    test "with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Categories.update_category(category, @invalid_attrs)
      assert category == Categories.get_category!(category.id)
    end
  end

  describe "#delete_category/1" do
    test "deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Categories.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Categories.get_category!(category.id) end
    end
  end

  describe "#change_category/1" do
    test "returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Categories.change_category(category)
    end
  end

  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Categories.create_category()

    category
  end
end
