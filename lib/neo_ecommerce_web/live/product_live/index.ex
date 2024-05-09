defmodule NeoEcommerceWeb.ProductLive.Index do
  use NeoEcommerceWeb, :live_view

  alias NeoEcommerce.Products.Products
  alias NeoEcommerce.Products.Schemas.Product

  @topic "products:all"

  def mount(_params, _session, socket) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(NeoEcommerce.PubSub, @topic)

    {:ok, assign(socket, products: list_products())}
  end

  def handle_info({:product_created, product}, socket) do
    {:noreply, update(socket, :products, &[product | &1])}
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

  defp list_products do
    Products.list_products()
  end
end
