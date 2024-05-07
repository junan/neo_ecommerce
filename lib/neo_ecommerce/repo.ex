defmodule NeoEcommerce.Repo do
  use Ecto.Repo,
    otp_app: :neo_ecommerce,
    adapter: Ecto.Adapters.Postgres
end
