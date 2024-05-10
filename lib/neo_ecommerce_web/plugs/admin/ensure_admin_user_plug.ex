defmodule NeoEcommerceWeb.Admin.EnsureAdminUserPlug do
  @moduledoc false

  alias NeoEcommerce.Repo

  @router NeoEcommerceWeb.Router

  import Plug.Conn
  import Phoenix.Controller
  import Phoenix.VerifiedRoutes

  def init(opts), do: opts

  def call(conn, _opts) do
    user = conn.assigns[:current_user] |> Repo.preload(:roles)

    if user_has_role?(user, "admin") do
      conn
    else
      conn
      |> put_flash(:error, "You don't have permission to access this page.")
      |> redirect(to: path(conn, ~p"/"))
      |> halt()
    end
  end

  defp user_has_role?(%{roles: roles}, role_name) do
    Enum.any?(roles, fn role -> String.downcase(role.name) == String.downcase(role_name) end)
  end

  defp user_has_role?(_, _), do: false
end
