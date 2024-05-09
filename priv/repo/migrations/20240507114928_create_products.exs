defmodule NeoEcommerce.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def up do
    create table(:products) do
      add :name, :string, null: false
      add :description, :text
      add :price, :decimal, null: false
      add :inventory_count, :integer, default: 0, null: false

      add :category_id, references(:categories, on_delete: :nilify_all), null: true

      timestamps(type: :utc_datetime)
    end

    create index(:products, [:category_id])
    create unique_index(:products, [:name])

    create constraint(:products, :price_greater_than_zero_check, check: "price > 0")

    create constraint(:products, :inventory_count_non_negative_check,
             check: "inventory_count >= 0"
           )
  end

  def down do
    drop constraint(:products, :price_greater_than_zero_check)
    drop constraint(:products, :inventory_count_non_negative_check)
    drop table(:products)
  end
end
