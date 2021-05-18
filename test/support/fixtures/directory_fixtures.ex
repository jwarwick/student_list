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

  @doc """
  Generate a address.
  """
  def address_fixture(attrs \\ %{}) do
    {:ok, address} =
      attrs
      |> Enum.into(%{
        address1: "some address1",
        address2: "some address2",
        city: "some city",
        phone: "some phone",
        state: "some state",
        zip: "some zip"
      })
      |> StudentList.Directory.create_address()

    address
  end

  @doc """
  Generate a student.
  """
  def student_fixture(attrs \\ %{}) do
    {:ok, student} =
      attrs
      |> Enum.into(%{
        first_name: "some first_name",
        last_name: "some last_name",
        notes: "some notes"
      })
      |> StudentList.Directory.create_student()

    student
  end

  @doc """
  Generate a adult.
  """
  def adult_fixture(attrs \\ %{}) do
    {:ok, adult} =
      attrs
      |> Enum.into(%{
        email: "some email",
        first_name: "some first_name",
        last_name: "some last_name",
        mobile_phone: "some mobile_phone"
      })
      |> StudentList.Directory.create_adult()

    adult
  end
end
