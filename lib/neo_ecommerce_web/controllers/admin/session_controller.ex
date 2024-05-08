defmodule NeoEcommerceWeb.Admin.SessionController do
  use NeoEcommerceWeb, :controller

  alias NeoEcommerce.Authentication.Auth

  def new(conn, _params) do
    # TODO: Remove this line
    csrf_token = Plug.CSRFProtection.get_csrf_token()
    render(conn, "new.html", csrf_token: csrf_token)
  end

  def create(conn, %{"email" => email, "password" => password}) do
    IO.inspect(Auth.authenticate_user(email, password), label: "debug")

    case Auth.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Logged in successfully.")
        |> redirect(to: "/")

      {:error, :invalid_credentials} ->
        csrf_token = Plug.CSRFProtection.get_csrf_token()

        conn
        |> put_flash(:error, "Invalid email or password.")
        |> render("new.html", csrf_token: csrf_token)
    end
  end

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:info, "Logged out successfully.")
    |> redirect(to: "/")
  end
end
