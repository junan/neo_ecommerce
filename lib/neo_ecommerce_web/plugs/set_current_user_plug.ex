defmodule NeoEcommerceWeb.SetCurrentUserPlug do
  @moduledoc false

  import Plug.Conn

  alias NeoEcommerce.Accounts.Users

  @doc """
  Initializes any arguments or options to be passed to `call/2`
  """
  @spec init(Keyword.t()) :: Keyword.t()
  def init(opts), do: opts

  @doc """
  Sets the current user in the connection assigns. So that later can be get by `conn.assigns[:current_user]`
  """
  @spec call(Plug.Conn.t(), Keyword.t()) :: Plug.Conn.t()
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
