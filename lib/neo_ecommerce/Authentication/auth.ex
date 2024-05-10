defmodule NeoEcommerce.Authentication.Auth do
  @moduledoc false

  alias NeoEcommerce.Accounts.Users
  alias NeoEcommerce.Accounts.Schemas.User
  alias NeoEcommerce.Auth.Hasher

  @doc """
  Authenticates a user by its email and password.
  """
  @spec authenticate_user(String.t(), String.t()) ::
          {:ok, User.t()} | {:error, :invalid_credentials}
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
