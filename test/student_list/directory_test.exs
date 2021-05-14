defmodule StudentList.DirectoryTest do
  use StudentList.DataCase

  alias StudentList.Directory

  describe "buses" do
    alias StudentList.Directory.Bus

    @valid_attrs %{display_order: 42, name: "some name", should_display: true}
    @update_attrs %{display_order: 43, name: "some updated name", should_display: false}
    @invalid_attrs %{display_order: nil, name: nil, should_display: nil}

    def bus_fixture(attrs \\ %{}) do
      {:ok, bus} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Directory.create_bus()

      bus
    end

    test "paginate_buses/1 returns paginated list of buses" do
      for _ <- 1..20 do
        bus_fixture()
      end

      {:ok, %{buses: buses} = page} = Directory.paginate_buses(%{})

      assert length(buses) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_buses/0 returns all buses" do
      bus = bus_fixture()
      assert Directory.list_buses() == [bus]
    end

    test "get_bus!/1 returns the bus with given id" do
      bus = bus_fixture()
      assert Directory.get_bus!(bus.id) == bus
    end

    test "create_bus/1 with valid data creates a bus" do
      assert {:ok, %Bus{} = bus} = Directory.create_bus(@valid_attrs)
      assert bus.display_order == 42
      assert bus.name == "some name"
      assert bus.should_display == true
    end

    test "create_bus/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Directory.create_bus(@invalid_attrs)
    end

    test "update_bus/2 with valid data updates the bus" do
      bus = bus_fixture()
      assert {:ok, bus} = Directory.update_bus(bus, @update_attrs)
      assert %Bus{} = bus
      assert bus.display_order == 43
      assert bus.name == "some updated name"
      assert bus.should_display == false
    end

    test "update_bus/2 with invalid data returns error changeset" do
      bus = bus_fixture()
      assert {:error, %Ecto.Changeset{}} = Directory.update_bus(bus, @invalid_attrs)
      assert bus == Directory.get_bus!(bus.id)
    end

    test "delete_bus/1 deletes the bus" do
      bus = bus_fixture()
      assert {:ok, %Bus{}} = Directory.delete_bus(bus)
      assert_raise Ecto.NoResultsError, fn -> Directory.get_bus!(bus.id) end
    end

    test "change_bus/1 returns a bus changeset" do
      bus = bus_fixture()
      assert %Ecto.Changeset{} = Directory.change_bus(bus)
    end
  end

  describe "classes" do
    alias StudentList.Directory.Class

    @valid_attrs %{display_order: 42, name: "some name", teacher: "some teacher"}
    @update_attrs %{display_order: 43, name: "some updated name", teacher: "some updated teacher"}
    @invalid_attrs %{display_order: nil, name: nil, teacher: nil}

    def class_fixture(attrs \\ %{}) do
      {:ok, class} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Directory.create_class()

      class
    end

    test "paginate_classes/1 returns paginated list of classes" do
      for _ <- 1..20 do
        class_fixture()
      end

      {:ok, %{classes: classes} = page} = Directory.paginate_classes(%{})

      assert length(classes) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_classes/0 returns all classes" do
      class = class_fixture()
      assert Directory.list_classes() == [class]
    end

    test "get_class!/1 returns the class with given id" do
      class = class_fixture()
      assert Directory.get_class!(class.id) == class
    end

    test "create_class/1 with valid data creates a class" do
      assert {:ok, %Class{} = class} = Directory.create_class(@valid_attrs)
      assert class.display_order == 42
      assert class.name == "some name"
      assert class.teacher == "some teacher"
    end

    test "create_class/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Directory.create_class(@invalid_attrs)
    end

    test "update_class/2 with valid data updates the class" do
      class = class_fixture()
      assert {:ok, class} = Directory.update_class(class, @update_attrs)
      assert %Class{} = class
      assert class.display_order == 43
      assert class.name == "some updated name"
      assert class.teacher == "some updated teacher"
    end

    test "update_class/2 with invalid data returns error changeset" do
      class = class_fixture()
      assert {:error, %Ecto.Changeset{}} = Directory.update_class(class, @invalid_attrs)
      assert class == Directory.get_class!(class.id)
    end

    test "delete_class/1 deletes the class" do
      class = class_fixture()
      assert {:ok, %Class{}} = Directory.delete_class(class)
      assert_raise Ecto.NoResultsError, fn -> Directory.get_class!(class.id) end
    end

    test "change_class/1 returns a class changeset" do
      class = class_fixture()
      assert %Ecto.Changeset{} = Directory.change_class(class)
    end
  end
end
