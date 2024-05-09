alias NeoEcommerce.Repo
alias NeoEcommerce.Products.Schemas.{Category, Product}
alias NeoEcommerce.Accounts.Schemas.{User, Role}
alias NeoEcommerce.Auth.Hasher

# Helper function to read a CSV file and decode it
read_csv = fn file_path ->
  file_path
  |> File.stream!()
  |> CSV.decode!(headers: true)
  |> Enum.to_list()
end

# Populate Categories
populate_categories = fn ->
  categories_csv = Application.app_dir(:neo_ecommerce, "priv/data/development/categories.csv")

  categories_csv
  |> read_csv.()
  |> Enum.each(fn %{"id" => id, "name" => name} ->
    %Category{id: String.to_integer(id), name: name}
    |> Repo.insert!(on_conflict: :nothing, conflict_target: :id)
  end)
end

# Populate Products
populate_products = fn ->
  products_csv = Application.app_dir(:neo_ecommerce, "priv/data/development/products.csv")

  products_csv
  |> read_csv.()
  |> Enum.each(fn %{
                    "id" => id,
                    "name" => name,
                    "description" => description,
                    "inventory_count" => inventory_count,
                    "price" => price,
                    "category_id" => category_id
                  } ->
    %Product{
      id: String.to_integer(id),
      name: name,
      description: description,
      inventory_count: String.to_integer(inventory_count),
      price: Decimal.new(price),
      category_id: String.to_integer(category_id)
    }
    |> Repo.insert!(on_conflict: :nothing, conflict_target: :id)
  end)
end

# Populate Roles
populate_roles = fn ->
  roles_csv = Application.app_dir(:neo_ecommerce, "priv/data/development/roles.csv")

  roles_csv
  |> read_csv.()
  |> Enum.each(fn %{"id" => id, "name" => name} ->
    %Role{id: String.to_integer(id), name: name}
    |> Repo.insert!(on_conflict: :nothing, conflict_target: :id)
  end)
end

# Populate Users
populate_users = fn ->
  users_csv = Application.app_dir(:neo_ecommerce, "priv/data/development/admin_users.csv")

  users_csv
  |> read_csv.()
  |> Enum.each(fn %{
                    "id" => id,
                    "first_name" => first_name,
                    "last_name" => last_name,
                    "email" => email,
                    "password" => password
                  } ->
    password_hash = Hasher.hash_secret(password, :argon2)

    %User{
      id: String.to_integer(id),
      first_name: first_name,
      last_name: last_name,
      email: email,
      password_hash: password_hash
    }
    |> Repo.insert!(on_conflict: :nothing, conflict_target: :id)
  end)
end

# Associate Users and Roles
associate_users_roles = fn ->
  users_roles_csv = Application.app_dir(:neo_ecommerce, "priv/data/development/users_roles.csv")

  list =
    users_roles_csv
    |> read_csv.()
    |> Enum.map(fn %{"user_id" => user_id, "role_id" => role_id} ->
      %{
        user_id: String.to_integer(user_id),
        role_id: String.to_integer(role_id)
      }
    end)

  Repo.insert_all("users_roles", list)
end

populate_categories.()
populate_products.()
populate_roles.()
populate_users.()
associate_users_roles.()
