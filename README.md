# Neo E-commerce

Neo E-commerce is a real-time e-commerce platform written in Elixir/Phoenix/LiveView

## Key Features

- **Product Listing**: Users can browse all the products
- **Admin Inventory Management**: Admins can manage product inventory
- **Real-time Inventory Updates**: Inventory changes(any change, like add/edit/delete products) are updated in real time in the product listing for all users with
- **Sorting, and Filtering, Pagination**: Highly interactive sorting/filtering/pagination support(sync with realtime inventory updates too), powered by LiveView
- **Real-time User Tracking**: Shows the number of current users viewing the page.

## Getting Started

These instructions help you up and run the project on your local machine.

### Prerequisites

- Erlang 25
- Elixir 1.14

### Running external services

- Start PostgreSQL (ex: `brew services start postgresql`)

### Install dependencies, then Up and Running

- Install dependencies:

  ```sh
  mix deps.get
  ```

- Setup the databases:

  ```sh
  mix ecto.setup
  ```

- Run all tests:

  ```sh
  mix test
  ```

- Run `credo`

  ```sh
  mix credo
  ```

- Start the Phoenix app

  ```sh
  mix phx.server
  ```

### Usage on locally

1. The server should access at `http://localhost:4023`
2. You should see some pre-populated products there, where you can sort, filter, paginate products

3. For admin access, navigate `http://localhost:4023/admin`
4. Use `john.doe@example.com` and `admin` as credential to login
5. After login as admin, you can add/edit/delete products there, for every action, it will update in realtime the public product list page for all users.
6. You can create/edit/update categories too there
