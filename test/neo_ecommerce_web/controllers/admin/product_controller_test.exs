defmodule NeoEcommerceWeb.Admin.ProductControllerTest do
  use NeoEcommerceWeb.ConnCase

  alias NeoEcommerce.Products.Products

  @create_attrs %{description: "some description", inventory_count: 42, name: "some name", price: "120.5"}
  @update_attrs %{description: "some updated description", inventory_count: 43, name: "some updated name", price: "456.7"}
  @invalid_attrs %{description: nil, inventory_count: nil, name: nil, price: nil}

  def fixture(:product) do
    {:ok, product} = Products.create_product(@create_attrs)
    product
  end

  describe "index" do
    test "lists all products", %{conn: conn} do
      conn = get conn, ~p"/admin/products"
      assert html_response(conn, 200) =~ "Products"
    end
  end

  describe "new product" do
    test "renders form", %{conn: conn} do
      conn = get conn, ~p"/admin/products/new"
      assert html_response(conn, 200) =~ "New Product"
    end
  end

  describe "create product" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, ~p"/admin/products", product: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == "/admin/products/#{id}"

      conn = get conn, ~p"/admin/products/#{id}"
      assert html_response(conn, 200) =~ "Product Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, ~p"/admin/products", product: @invalid_attrs
      assert html_response(conn, 200) =~ "New Product"
    end
  end

  describe "edit product" do
    setup [:create_product]

    test "renders form for editing chosen product", %{conn: conn, product: product} do
      conn = get conn, ~p"/admin/products/#{product}/edit"
      assert html_response(conn, 200) =~ "Edit Product"
    end
  end

  describe "update product" do
    setup [:create_product]

    test "redirects when data is valid", %{conn: conn, product: product} do
      conn = put conn, ~p"/admin/products/#{product}", product: @update_attrs
      assert redirected_to(conn) == ~p"/admin/products/#{product}"

      conn = get conn, ~p"/admin/products/#{product}" 
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, product: product} do
      conn = put conn, ~p"/admin/products/#{product}", product: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Product"
    end
  end

  describe "delete product" do
    setup [:create_product]

    test "deletes chosen product", %{conn: conn, product: product} do
      conn = delete conn, ~p"/admin/products/#{product}"
      assert redirected_to(conn) == "/admin/products"
      assert_error_sent 404, fn ->
        get conn, ~p"/admin/products/#{product}"
      end
    end
  end

  defp create_product(_) do
    product = fixture(:product)
    {:ok, product: product}
  end
end
