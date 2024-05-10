defmodule NeoEcommerce.Products.ViewerCount do
  @moduledoc false

  use GenServer

  @table_name :viewer_count

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def increment do
    GenServer.call(__MODULE__, :increment)
  end

  def decrement do
    GenServer.call(__MODULE__, :decrement)
  end

  def get_count do
    case :ets.lookup(@table_name, :count) do
      [{:count, count}] -> count
      _ -> 0
    end
  end

  @impl true
  def init(_opts) do
    :ets.new(@table_name, [:named_table, :public, :set, {:read_concurrency, true}])
    set_count(0)
    {:ok, %{}}
  end

  @impl true
  def handle_call(:increment, _from, state) do
    :ets.update_counter(@table_name, :count, {2, 1}, {:count, 0})
    {:reply, :ok, state}
  end

  @impl true
  def handle_call(:decrement, _from, state) do
    :ets.update_counter(@table_name, :count, {2, -1}, {:count, 0})
    {:reply, :ok, state}
  end

  defp set_count(count) do
    :ets.insert(@table_name, {:count, count})
  end
end
