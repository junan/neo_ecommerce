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

  @doc """
  Mount the live view, initializing default assignments and subscribing to the PubSub topic `products:all`
  """
  @spec mount(map(), Phoenix.LiveView.Socket.t(), Phoenix.LiveView.Socket.t()) ::
          {:ok, Phoenix.LiveView.Socket.t()}
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

  @doc """
  Handle URL parameters to update sorting, filtering, and pagination.
  """
  @spec handle_params(map(), String.t(), Phoenix.LiveView.Socket.t()) ::
          {:noreply, Phoenix.LiveView.Socket.t()}
  def handle_params(params, _url, socket) do
    sort_by = Map.get(params, "sort_by", "name_asc")
    filter_category = Map.get(params, "filter_category", nil)
    page = Map.get(params, "page", "1") |> String.to_integer()
    page_size = Map.get(params, "page_size") |> parse_page_size(socket)

    new_socket =
      socket
      |> assign(:sort_by, sort_by)
      |> assign(
        :filter_category,
        if(filter_category in [nil, ""], do: nil, else: String.to_integer(filter_category))
      )
      |> assign(:page, page)
      |> maybe_assign_page_size(page_size)

    {:noreply, assign(new_socket, :products, list_products(new_socket))}
  end

  @doc """
  Handle incoming Product create PubSub message to update the list of products by adding the newly created product by admin.
  Note that it works with the sort, filter, and pagination features, ensuring the new product is displayed on the correct page.
  """
  @spec handle_info({:product_created, Product.t()}, Phoenix.LiveView.Socket.t()) ::
          {:noreply, Phoenix.LiveView.Socket.t()}
  def handle_info({:product_created, _product}, socket) do
    {:noreply, assign(socket, :products, list_products(socket))}
  end

  @doc """
  Handle incoming Product update PubSub message to update product in the product list page with the newly updated product(can update all product attributes, including inventory count) by admin.
  It also works with the sort, filter, and pagination features, ensuring the updated product is displayed on the correct page.
  """
  @spec handle_info({:product_updated, Product.t()}, Phoenix.LiveView.Socket.t()) ::
          {:noreply, Phoenix.LiveView.Socket.t()}
  def handle_info({:product_updated, product}, socket) do
    products =
      Enum.map(socket.assigns.products, fn
        p when p.id == product.id -> product
        p -> p
      end)

    {:noreply, assign(socket, :products, products)}
  end

  @doc """
  Handle incoming Product delete PubSub message to delete the product from the product list page when the product is deleted by admin by admin.
  It also works with the sort, filter, and pagination features, ensuring the updated product is deleted on the correct page.
  """
  @spec handle_info({:product_deleted, Product.t()}, Phoenix.LiveView.Socket.t()) ::
          {:noreply, Phoenix.LiveView.Socket.t()}
  def handle_info({:product_deleted, product}, socket) do
    products = Enum.reject(socket.assigns.products, fn p -> p.id == product.id end)
    {:noreply, assign(socket, :products, products)}
  end

  @doc """
  Increment the user count when a viewer/guest user visit the product listing page.
  """
  @spec handle_info({:viewer_joined}, Phoenix.LiveView.Socket.t()) ::
          {:noreply, Phoenix.LiveView.Socket.t()}
  def handle_info({:viewer_joined}, socket) do
    {:noreply, assign(socket, :user_count, socket.assigns.user_count + 1)}
  end

  @doc """
  Decrement the user count when a viewer/guest user leaves the product listing page.
  """
  @spec handle_info({:viewer_left}, Phoenix.LiveView.Socket.t()) ::
          {:noreply, Phoenix.LiveView.Socket.t()}
  def handle_info({:viewer_left}, socket) do
    {:noreply, assign(socket, :user_count, max(socket.assigns.user_count - 1, 0))}
  end

  @doc """
  Broadcasting the `viewer_left` message to update the user count. And also, decrement the user count in the ETS where we store the user count.
  """
  @spec terminate(String.t(), Phoenix.LiveView.Socket.t()) :: :ok
  def terminate(_reason, _socket) do
    Phoenix.PubSub.broadcast(NeoEcommerce.PubSub, @topic, {:viewer_left})
    ViewerCount.decrement()
    :ok
  end

  @doc """
  Handle live view events for filtering by category, and it use `push_patch/2` for update the url with the category query.
  This is needed as filtering feature is based on live view, so we need to update URLs to make it shareable. This is same for sorting and pagination too!
  """
  @spec handle_event(String.t(), map(), Phoenix.LiveView.Socket.t()) ::
          {:noreply, Phoenix.LiveView.Socket.t()}
  def handle_event("filter", %{"filter_category" => category_id}, socket) do
    filter_category = if category_id == "", do: nil, else: String.to_integer(category_id)

    new_socket = assign(socket, :filter_category, filter_category)

    {:noreply, push_patch(new_socket, to: ~p"/?#{build_query_params(new_socket)}")}
  end

  @doc """
  Handle live view events for sorting by name, price, and inventory count.
  """
  @spec handle_event(String.t(), map(), Phoenix.LiveView.Socket.t()) ::
          {:noreply, Phoenix.LiveView.Socket.t()}
  def handle_event("sort", %{"sort_by" => sort_by}, socket) do
    new_socket = assign(socket, :sort_by, sort_by)

    {:noreply, push_patch(new_socket, to: ~p"/?#{build_query_params(new_socket)}")}
  end

  @doc """
  Handle live view events for pagination to go to the next page.
  """
  @spec handle_event(String.t(), map(), Phoenix.LiveView.Socket.t()) ::
          {:noreply, Phoenix.LiveView.Socket.t()}
  def handle_event("next_page", _params, socket) do
    new_socket = assign(socket, :page, socket.assigns.page + 1)

    {:noreply, push_patch(new_socket, to: ~p"/?#{build_query_params(new_socket)}")}
  end

  @doc """
  Handle live view events for pagination to go to the previous page.
  """
  @spec handle_event(String.t(), map(), Phoenix.LiveView.Socket.t()) ::
          {:noreply, Phoenix.LiveView.Socket.t()}
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

  defp parse_page_size(nil, socket), do: socket.assigns.page_size
  defp parse_page_size(size, _socket), do: String.to_integer(size)

  defp maybe_assign_page_size(socket, page_size) do
    assign(socket, :page_size, page_size)
  end
end
