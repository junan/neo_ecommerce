defmodule NeoEcommerceWeb.SetCurrentUserPlug do
  import Plug.Conn

  alias NeoEcommerce.Accounts.Users

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)

    user =
      if user_id do
        Users.get_user_by_id(user_id)
      else
        nil
      end

    assign(conn, :current_user, user)
  end
end
