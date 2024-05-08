defmodule NeoEcommerce.Auth.Hasher do
  def hash_secret(secret, :argon2), do: Argon2.hash_pwd_salt(secret)
  def hash_secret(secret, :sha256), do: :crypto.hash(:sha256, secret)

  def verify_secret(secret, hashed_secret, :argon2), do: Argon2.verify_pass(secret, hashed_secret)

  # Run the password hash function to prevent Timing Attacks
  def no_verify, do: Argon2.no_user_verify()
end
