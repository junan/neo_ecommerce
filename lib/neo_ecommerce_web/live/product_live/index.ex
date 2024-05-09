defmodule NeoEcommerceWeb.ProductLive.Index do
  use NeoEcommerceWeb, :live_view

  alias NeoEcommerce.Products.Products
  alias NeoEcommerce.Products.Categories
  alias NeoEcommerce.Products.ViewerCount

  @topic "products:all"

  @sort_options [
    {"Name (A-Z)", "name_asc"},
    {"Name (Z-A)", "name_desc"},
    {"Price (Low to High)", "price_asc"},
    {"Price (High to Low)", "price_desc"},
    {"Inventory (Low to High)", "inventory_asc"},
    {"Inventory (High to Low)", "inventory_desc"}
  ]

  @paginate_size 12

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(NeoEcommerce.PubSub, @topic)
      Phoenix.PubSub.broadcast(NeoEcommerce.PubSub, @topic, {:viewer_joined})
      ViewerCount.increment()
    end

    socket =
      socket
      |> assign(:products, [])
      |> assign(:categories, list_categories())
      |> assign(:sort_by, "name_asc")
      |> assign(:filter_category, nil)
      |> assign(:page, 1)
      |> assign(:page_size, @paginate_size)
      |> assign(:sort_options, @sort_options)
      |> assign(:user_count, ViewerCount.get_count())

    {:ok, assign(socket, :products, list_products(socket))}
  end

  def handle_params(params, _url, socket) do
    sort_by = Map.get(params, "sort_by", "name_asc")
    filter_category = Map.get(params, "filter_category", nil)
    page = Map.get(params, "page", "1") |> String.to_integer()

    new_socket =
      socket
      |> assign(:sort_by, sort_by)
      |> assign(
        :filter_category,
        if(filter_category in [nil, ""], do: nil, else: String.to_integer(filter_category))
      )
      |> assign(:page, page)

    {:noreply, assign(new_socket, :products, list_products(new_socket))}
  end

  def handle_info({:product_created, _product}, socket) do
    {:noreply, assign(socket, :products, list_products(socket))}
  end

  def handle_info({:product_updated, product}, socket) do
    products =
      Enum.map(socket.assigns.products, fn
        p when p.id == product.id -> product
        p -> p
      end)

    {:noreply, assign(socket, :products, products)}
  end

  def handle_info({:product_deleted, product}, socket) do
    products = Enum.reject(socket.assigns.products, fn p -> p.id == product.id end)
    {:noreply, assign(socket, :products, products)}
  end

  def handle_info({:viewer_joined}, socket) do
    {:noreply, assign(socket, :user_count, socket.assigns.user_count + 1)}
  end

  def handle_info({:viewer_left}, socket) do
    {:noreply, assign(socket, :user_count, max(socket.assigns.user_count - 1, 0))}
  end

  def terminate(_reason, _socket) do
    Phoenix.PubSub.broadcast(NeoEcommerce.PubSub, @topic, {:viewer_left})
    ViewerCount.decrement()
    :ok
  end

  def handle_event("filter", %{"filter_category" => category_id}, socket) do
    filter_category = if category_id == "", do: nil, else: String.to_integer(category_id)

    new_socket = assign(socket, :filter_category, filter_category)

    {:noreply, push_patch(new_socket, to: ~p"/?#{build_query_params(new_socket)}")}
  end

  def handle_event("sort", %{"sort_by" => sort_by}, socket) do
    new_socket = assign(socket, :sort_by, sort_by)

    {:noreply, push_patch(new_socket, to: ~p"/?#{build_query_params(new_socket)}")}
  end

  def handle_event("next_page", _params, socket) do
    new_socket = assign(socket, :page, socket.assigns.page + 1)

    {:noreply, push_patch(new_socket, to: ~p"/?#{build_query_params(new_socket)}")}
  end

  def handle_event("previous_page", _params, socket) do
    new_socket = assign(socket, :page, max(socket.assigns.page - 1, 1))

    {:noreply, push_patch(new_socket, to: ~p"/?#{build_query_params(new_socket)}")}
  end

  defp list_products(socket) do
    Products.list_products()
    |> apply_sort(socket.assigns.sort_by)
    |> apply_filter(socket.assigns.filter_category)
    |> paginate(socket.assigns.page, socket.assigns.page_size)
  end

  defp list_categories do
    Categories.list_categories()
  end

  defp apply_filter(products, nil), do: products

  defp apply_filter(products, category_id) do
    Enum.filter(products, &(&1.category_id == category_id))
  end

  defp apply_sort(products, "name_asc"), do: Enum.sort_by(products, & &1.name)
  defp apply_sort(products, "name_desc"), do: Enum.sort_by(products, & &1.name, &>=/2)
  defp apply_sort(products, "price_asc"), do: Enum.sort_by(products, & &1.price)
  defp apply_sort(products, "price_desc"), do: Enum.sort_by(products, & &1.price, &>=/2)
  defp apply_sort(products, "inventory_asc"), do: Enum.sort_by(products, & &1.inventory_count)

  defp apply_sort(products, "inventory_desc"),
    do: Enum.sort_by(products, & &1.inventory_count, &>=/2)

  defp apply_sort(products, _), do: products

  defp build_query_params(socket) do
    %{
      sort_by: socket.assigns.sort_by,
      filter_category: socket.assigns.filter_category,
      page: socket.assigns.page
    }
  end

  defp paginate(products, page, page_size) do
    products
    |> Enum.chunk_every(page_size)
    |> Enum.at(page - 1, [])
  end
end
