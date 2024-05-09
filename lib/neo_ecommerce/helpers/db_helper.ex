defmodule NeoEcommerce.Helpers.DbHelper do
  import Ecto.Query

  alias NeoEcommerce.Repo

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
