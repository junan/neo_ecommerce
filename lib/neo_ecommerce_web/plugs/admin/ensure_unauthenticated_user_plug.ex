defmodule NeoEcommerceWeb.Admin.EnsureUnauthenticatedUserPlug do
  @moduledoc false

  @router NeoEcommerceWeb.Router

  import Plug.Conn
  import Phoenix.Controller
  import Phoenix.VerifiedRoutes

  @doc """
  Initializes any arguments or options to be passed to `call/2`
  """
  @spec init(Keyword.t()) :: Keyword.t()
  def init(opts), do: opts

  @doc """
  Ensures that the user is not authenticated, the user need to be a guest user
  """
  @spec call(Plug.Conn.t(), Keyword.t()) :: Plug.Conn.t()
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
