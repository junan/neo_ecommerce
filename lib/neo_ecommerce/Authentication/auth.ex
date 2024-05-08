defmodule NeoEcommerce.Authentication.Auth do
  alias NeoEcommerce.Accounts.Users
  alias NeoEcommerce.Accounts.Schemas.User
  alias NeoEcommerce.Auth.Hasher

  def authenticate_user(email, password) do
    with %User{} = user <- Users.get_user_by_email(email),
         {:ok, user} <- validate_user_password(user, password) do
      {:ok, user}
    else
      nil ->
        Hasher.no_verify()
        {:error, :invalid_credentials}

      {:error, :invalid_credentials} ->
        {:error, :invalid_credentials}
    end
  end

  defp validate_user_password(user, password) do
    if Hasher.verify_secret(password, user.password_hash, :argon2) do
      {:ok, user}
    else
      {:error, :invalid_credentials}
    end
  end
end
