defmodule NeoEcommerceWeb.PageController do
  use NeoEcommerceWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false, current_user: conn.assigns.current_user, conn: conn)
  end
end
