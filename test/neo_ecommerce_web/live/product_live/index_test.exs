defmodule NeoEcommerceWeb.ProductLive.IndexTest do
  use NeoEcommerceWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  alias NeoEcommerce.Products.{Products, Schemas.Category, Schemas.Product}

  describe "Sorting, filtering and pagination" do
    setup do
      {:ok, electronics_category} = %Category{name: "Electronics"} |> NeoEcommerce.Repo.insert()

      {:ok, book_category} = %Category{name: "Book"} |> NeoEcommerce.Repo.insert()

      products = [
        %Product{
          name: "Smartphone",
          description: "A nice phone",
          inventory_count: 10,
          price: Decimal.new(500),
          category_id: electronics_category.id
        },
        %Product{
          name: "A brief history of Time",
          description: "One of the most important books of the 20th century",
          inventory_count: 5,
          price: Decimal.new(40),
          category_id: book_category.id
        },
        %Product{
          name: "Tablet",
          description: "A nice tablet",
          inventory_count: 20,
          price: Decimal.new(300),
          category_id: electronics_category.id
        }
      ]

      products =
        Enum.map(products, fn product ->
          Products.create_product(Map.from_struct(product)) |> elem(1)
        end)

      {:ok, category: electronics_category, products: products}
    end

    test "displays list of products", %{conn: conn, products: products} do
      {:ok, _view, html} = live(conn, ~p"/")

      # Check that each product is displayed on the page
      for product <- products do
        assert html =~ product.name
        assert html =~ Decimal.to_string(product.price)
      end
    end

    test "filtering products by category", %{conn: conn, category: category} do
      {:ok, view, _html} = live(conn, ~p"/")

      view
      |> form("#filter_category_form", %{"filter_category" => category.id})
      |> render_change()

      rendered_html = render(view)
      assert rendered_html =~ "Electronics"
      # book category product should not be displayed
      refute rendered_html =~ "A brief history of Time"
    end

    test "sort products by price ascending", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/")

      view
      |> form("#sort_form", %{"sort_by" => "price_asc"})
      |> render_change()

      # Ensure products are sorted by price ascending
      rendered_html = render(view)
      # price: 40
      assert rendered_html =~ "A brief history of Time"
      # price: 300
      assert rendered_html =~ "A nice tablet"
      # price: 500
      assert rendered_html =~ "A nice phone"
    end

    test "pagination", %{conn: conn, products: products} do
      Application.put_env(:neo_ecommerce, NeoEcommerceWeb.ProductLive.Index, paginate_size: 2)

      # passing `page_size=2` so we dont need to generate 13(default page per pagination is 12) records to test pagination
      {:ok, view, _html} = live(conn, ~p"/?page_size=2")

      assert render(view) =~ Enum.at(products, 0).name
      assert render(view) =~ Enum.at(products, 1).name

      # 3rd product
      refute render(view) =~ Enum.at(products, 2).name

      # Click to the next page
      view
      |> element("button", "Next")
      |> render_click()

      # 3rd product
      assert render(view) =~ Enum.at(products, 2).name
    end
  end
end
