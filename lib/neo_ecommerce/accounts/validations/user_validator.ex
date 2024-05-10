defmodule NeoEcommerce.Accounts.Validations.UserValidator do
  @moduledoc false

  import Ecto.Changeset

  @email_regex ~r/^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i

  @password_min_length 5

  @doc """
  Validates the email field in the changeset
  """
  @spec validate_email(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  def validate_email(changeset),
    do: validate_format(changeset, :email, @email_regex)

  @doc """
  Validates the password field in the changeset
  """
  @spec validate_password(Ecto.Changeset.t(), atom) :: Ecto.Changeset.t()
  def validate_password(changeset, field \\ :password) do
    changeset
    |> validate_length(field, min: @password_min_length)
  end
end
