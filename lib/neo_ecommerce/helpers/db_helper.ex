defmodule NeoEcommerce.Helpers.DbHelper do
  @moduledoc false

  alias NeoEcommerce.Repo

  @doc """
  Resets the sequence of a table’s primary key to the maximum value. This function is needed as in the `/priv/repo/seeds.exs` file, we are inserting data into the tables and the primary key sequence is not updated. This function is called in the `/priv/repo/seeds.exs` file.
  """
  @spec reset_pk_sequence!(String.t()) :: :ok
  def reset_pk_sequence!(table_name) do
    sql = """
    DO $$ BEGIN
      IF EXISTS (SELECT * FROM information_schema.tables WHERE table_schema = 'public' AND table_name = '#{table_name}') THEN
        PERFORM setval(pg_get_serial_sequence('#{table_name}', 'id'), COALESCE(MAX(id), 1) + 1, false) FROM #{table_name};
      END IF;
    END $$;
    """

    {:ok, _} = Ecto.Adapters.SQL.query(Repo, sql, [])
  end
end
