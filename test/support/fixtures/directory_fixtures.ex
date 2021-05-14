defmodule StudentList.DirectoryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `StudentList.Directory` context.
  """

  @doc """
  Generate a bus.
  """
  def bus_fixture(attrs \\ %{}) do
    {:ok, bus} =
      attrs
      |> Enum.into(%{
        display_order: 42,
        name: "some name",
        should_display: true
      })
      |> StudentList.Directory.create_bus()

    bus
  end

  @doc """
  Generate a class.
  """
  def class_fixture(attrs \\ %{}) do
    {:ok, class} =
      attrs
      |> Enum.into(%{
        display_order: 42,
        name: "some name",
        teacher: "some teacher"
      })
      |> StudentList.Directory.create_class()

    class
  end
end
