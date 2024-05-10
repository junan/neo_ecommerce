defmodule NeoEcommerce.Auth.Hasher do
  @moduledoc false

  @doc """
  Hashes a secret/password using the Argon2 algorithm.
  Note that Argon2 is the recommended algorithm for hashing passwords as it is the winner of the Password Hashing Competition.
  More details can be found at [Password_Hashing_Competition](https://en.wikipedia.org/wiki/Password_Hashing_Competition)
  """
  @spec hash_secret(String.t(), atom()) :: String.t()
  def hash_secret(secret, :argon2), do: Argon2.hash_pwd_salt(secret)

  @doc """
  Verifies a secret/password using the Argon2 algorithm.
  """
  @spec verify_secret(String.t(), String.t(), atom()) :: boolean()
  def verify_secret(secret, hashed_secret, :argon2), do: Argon2.verify_pass(secret, hashed_secret)

  @doc """
   Runs the password hash function to prevent Timing Attacks
  """
  @spec no_verify() :: nil
  def no_verify, do: Argon2.no_user_verify()
end
