defmodule NeoEcommerceWeb.Admin.EnsureUnauthenticatedUserPlug do
  @moduledoc false

  @router NeoEcommerceWeb.Router

  import Plug.Conn
  import Phoenix.Controller
  import Phoenix.VerifiedRoutes

  def init(opts), do: opts

  def call(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: path(conn, ~p"/admin"))
      |> halt()
    else
      conn
    end
  end
end
