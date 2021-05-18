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

  describe "addresses" do
    alias StudentList.Directory.Address

    @valid_attrs %{address1: "some address1", address2: "some address2", city: "some city", phone: "some phone", state: "some state", zip: "some zip"}
    @update_attrs %{address1: "some updated address1", address2: "some updated address2", city: "some updated city", phone: "some updated phone", state: "some updated state", zip: "some updated zip"}
    @invalid_attrs %{address1: nil, address2: nil, city: nil, phone: nil, state: nil, zip: nil}

    def address_fixture(attrs \\ %{}) do
      {:ok, address} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Directory.create_address()

      address
    end

    test "paginate_addresses/1 returns paginated list of addresses" do
      for _ <- 1..20 do
        address_fixture()
      end

      {:ok, %{addresses: addresses} = page} = Directory.paginate_addresses(%{})

      assert length(addresses) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_addresses/0 returns all addresses" do
      address = address_fixture()
      assert Directory.list_addresses() == [address]
    end

    test "get_address!/1 returns the address with given id" do
      address = address_fixture()
      assert Directory.get_address!(address.id) == address
    end

    test "create_address/1 with valid data creates a address" do
      assert {:ok, %Address{} = address} = Directory.create_address(@valid_attrs)
      assert address.address1 == "some address1"
      assert address.address2 == "some address2"
      assert address.city == "some city"
      assert address.phone == "some phone"
      assert address.state == "some state"
      assert address.zip == "some zip"
    end

    test "create_address/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Directory.create_address(@invalid_attrs)
    end

    test "update_address/2 with valid data updates the address" do
      address = address_fixture()
      assert {:ok, address} = Directory.update_address(address, @update_attrs)
      assert %Address{} = address
      assert address.address1 == "some updated address1"
      assert address.address2 == "some updated address2"
      assert address.city == "some updated city"
      assert address.phone == "some updated phone"
      assert address.state == "some updated state"
      assert address.zip == "some updated zip"
    end

    test "update_address/2 with invalid data returns error changeset" do
      address = address_fixture()
      assert {:error, %Ecto.Changeset{}} = Directory.update_address(address, @invalid_attrs)
      assert address == Directory.get_address!(address.id)
    end

    test "delete_address/1 deletes the address" do
      address = address_fixture()
      assert {:ok, %Address{}} = Directory.delete_address(address)
      assert_raise Ecto.NoResultsError, fn -> Directory.get_address!(address.id) end
    end

    test "change_address/1 returns a address changeset" do
      address = address_fixture()
      assert %Ecto.Changeset{} = Directory.change_address(address)
    end
  end
end
