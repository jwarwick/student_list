defmodule StudentList.Directory do
  @moduledoc """
  The Directory context.
  """

  import Ecto.Query, warn: false
  alias StudentList.Repo
import Torch.Helpers, only: [sort: 1, paginate: 4]
import Filtrex.Type.Config

alias StudentList.Directory.Bus

@pagination [page_size: 15]
@pagination_distance 5

@doc """
Paginate the list of buses using filtrex
filters.

## Examples

    iex> list_buses(%{})
    %{buses: [%Bus{}], ...}
"""
@spec paginate_buses(map) :: {:ok, map} | {:error, any}
def paginate_buses(params \\ %{}) do
  params =
    params
    |> Map.put_new("sort_direction", "desc")
    |> Map.put_new("sort_field", "inserted_at")

  {:ok, sort_direction} = Map.fetch(params, "sort_direction")
  {:ok, sort_field} = Map.fetch(params, "sort_field")

  with {:ok, filter} <- Filtrex.parse_params(filter_config(:buses), params["bus"] || %{}),
       %Scrivener.Page{} = page <- do_paginate_buses(filter, params) do
    {:ok,
      %{
        buses: page.entries,
        page_number: page.page_number,
        page_size: page.page_size,
        total_pages: page.total_pages,
        total_entries: page.total_entries,
        distance: @pagination_distance,
        sort_field: sort_field,
        sort_direction: sort_direction
      }
    }
  else
    {:error, error} -> {:error, error}
    error -> {:error, error}
  end
end

defp do_paginate_buses(filter, params) do
  Bus
  |> Filtrex.query(filter)
  |> order_by(^sort(params))
  |> paginate(Repo, params, @pagination)
end

@doc """
Returns the list of buses.

## Examples

    iex> list_buses()
    [%Bus{}, ...]

"""
def list_buses do
  Repo.all(Bus)
end

@doc """
Gets a single bus.

Raises `Ecto.NoResultsError` if the Bus does not exist.

## Examples

    iex> get_bus!(123)
    %Bus{}

    iex> get_bus!(456)
    ** (Ecto.NoResultsError)

"""
def get_bus!(id), do: Repo.get!(Bus, id)

@doc """
Creates a bus.

## Examples

    iex> create_bus(%{field: value})
    {:ok, %Bus{}}

    iex> create_bus(%{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def create_bus(attrs \\ %{}) do
  %Bus{}
  |> Bus.changeset(attrs)
  |> Repo.insert()
end

@doc """
Updates a bus.

## Examples

    iex> update_bus(bus, %{field: new_value})
    {:ok, %Bus{}}

    iex> update_bus(bus, %{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def update_bus(%Bus{} = bus, attrs) do
  bus
  |> Bus.changeset(attrs)
  |> Repo.update()
end

@doc """
Deletes a Bus.

## Examples

    iex> delete_bus(bus)
    {:ok, %Bus{}}

    iex> delete_bus(bus)
    {:error, %Ecto.Changeset{}}

"""
def delete_bus(%Bus{} = bus) do
  Repo.delete(bus)
end

@doc """
Returns an `%Ecto.Changeset{}` for tracking bus changes.

## Examples

    iex> change_bus(bus)
    %Ecto.Changeset{source: %Bus{}}

"""
def change_bus(%Bus{} = bus, attrs \\ %{}) do
  Bus.changeset(bus, attrs)
end

defp filter_config(:buses) do
  defconfig do
    text :name
      number :display_order
      boolean :should_display
      
  end
end
end
