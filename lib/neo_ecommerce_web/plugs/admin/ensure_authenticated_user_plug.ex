defmodule NeoEcommerceWeb.Admin.EnsureAuthenticatedUserPlug do
  @moduledoc false

  @router NeoEcommerceWeb.Router

  import Plug.Conn
  import Phoenix.Controller
  import Phoenix.VerifiedRoutes

  alias NeoEcommerce.Accounts.Users

  @doc """
  Initializes any arguments or options to be passed to `call/2`
  """
  def init(opts), do: opts

  @doc """
  Ensures that the user is authenticated.
  """
  @spec call(Plug.Conn.t(), Keyword.t()) :: Plug.Conn.t()
  def call(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      user_id = get_session(conn, :user_id)
      user = user_id && Users.get_user_by_id(user_id)

      if user do
        assign(conn, :current_user, user)
      else
        conn
        |> put_flash(:error, "You must be logged in to access this page.")
        |> redirect(to: path(conn, ~p"/admin/login"))
        |> halt()
      end
    end
  end
end
