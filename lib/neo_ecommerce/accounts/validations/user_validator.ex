defmodule NeoEcommerce.Accounts.Validations.UserValidator do
  @moduledoc false

  import Ecto.Changeset

  @email_regex ~r/^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i

  @password_min_length 5

  def validate_email(changeset),
    do: validate_format(changeset, :email, @email_regex)

  def validate_password(changeset, field \\ :password) do
    changeset
    |> validate_length(field, min: @password_min_length)
  end
end
