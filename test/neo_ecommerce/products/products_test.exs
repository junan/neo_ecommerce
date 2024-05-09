defmodule NeoEcommerce.Products.ProductsTest do
  use NeoEcommerce.DataCase

  alias NeoEcommerce.Products.Products

  alias NeoEcommerce.Products.Products.Product

  @valid_attrs %{description: "some description", inventory_count: 42, name: "some name", price: "120.5"}
  @update_attrs %{description: "some updated description", inventory_count: 43, name: "some updated name", price: "456.7"}
  @invalid_attrs %{description: nil, inventory_count: nil, name: nil, price: nil}

  describe "#paginate_products/1" do
    test "returns paginated list of products" do
      for _ <- 1..20 do
        product_fixture()
      end

      {:ok, %{products: products} = page} = Products.paginate_products(%{})

      assert length(products) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end
  end

  describe "#list_products/0" do
    test "returns all products" do
      product = product_fixture()
      assert Products.list_products() == [product]
    end
  end

  describe "#get_product!/1" do
    test "returns the product with given id" do
      product = product_fixture()
      assert Products.get_product!(product.id) == product
    end
  end

  describe "#create_product/1" do
    test "with valid data creates a product" do
      assert {:ok, %Product{} = product} = Products.create_product(@valid_attrs)
      assert product.description == "some description"
      assert product.inventory_count == 42
      assert product.name == "some name"
      assert product.price == Decimal.new("120.5")
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product(@invalid_attrs)
    end
  end

  describe "#update_product/2" do
    test "with valid data updates the product" do
      product = product_fixture()
      assert {:ok, product} = Products.update_product(product, @update_attrs)
      assert %Product{} = product
      assert product.description == "some updated description"
      assert product.inventory_count == 43
      assert product.name == "some updated name"
      assert product.price == Decimal.new("456.7")
    end

    test "with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_product(product, @invalid_attrs)
      assert product == Products.get_product!(product.id)
    end
  end

  describe "#delete_product/1" do
    test "deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Products.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
    end
  end

  describe "#change_product/1" do
    test "returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Products.change_product(product)
    end
  end

  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Products.create_product()

    product
  end

end
