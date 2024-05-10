defmodule NeoEcommerce.Products.ViewerCount do
  @moduledoc """
  This module is responsible for keeping track of the guests user(technically subscribers) count viewing the products page.
  And the count is stored in an ETS table to synchronize the count across everywhere.
  """

  use GenServer

  @table_name :viewer_count

  @doc """
  Starts the GenServer.
  """
  @spec start_link(map()) :: GenServer.on_start()
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @doc """
  Increments the viewer count.
  """
  @spec increment() :: :ok
  def increment do
    GenServer.call(__MODULE__, :increment)
  end

  @doc """
  Decrements the viewer count.
  """
  @spec decrement() :: :ok
  def decrement do
    GenServer.call(__MODULE__, :decrement)
  end

  @doc """
  Gets the total viewer count.
  """
  @spec get_count() :: integer()
  def get_count do
    case :ets.lookup(@table_name, :count) do
      [{:count, count}] -> count
      _ -> 0
    end
  end

  @doc """
  Creates the ETS table where the count is stored.
  """
  @spec init(map()) :: {:ok, map()}
  @impl true
  def init(_opts) do
    :ets.new(@table_name, [:named_table, :public, :set, {:read_concurrency, true}])
    set_count(0)
    {:ok, %{}}
  end

  @doc """
  Handles the `:increment`/`:decrement` call to increase/decrease the viewer count.
  """
  @spec handle_call(atom(), any(), any()) :: {:reply, any(), any()}
  @impl true
  def handle_call(:increment, _from, state) do
    :ets.update_counter(@table_name, :count, {2, 1}, {:count, 0})
    {:reply, :ok, state}
  end

  @spec handle_call(:decrement, any(), any()) :: {:reply, any(), any()}
  @impl true
  def handle_call(:decrement, _from, state) do
    :ets.update_counter(@table_name, :count, {2, -1}, {:count, 0})
    {:reply, :ok, state}
  end

  defp set_count(count) do
    :ets.insert(@table_name, {:count, count})
  end
end
