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

      address |> Repo.preload([:adults, :students])
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

    test "create_address/1 with empty data creates an address" do
      assert {:ok, %Address{} = address} = Directory.create_address(@invalid_attrs)
      assert address.address1 == nil
      assert address.address2 == nil
      assert address.city == nil
      assert address.phone == nil
      assert address.state == nil
      assert address.zip == nil
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

    test "update_address/2 with empty data updates address" do
      address = address_fixture()
      assert {:ok, %Address{} = address} = Directory.update_address(address, @invalid_attrs)
      assert address.address1 == nil
      assert address.address2 == nil
      assert address.city == nil
      assert address.phone == nil
      assert address.state == nil
      assert address.zip == nil
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

  describe "students" do
    alias StudentList.Directory.Student

    @valid_attrs %{first_name: "some first_name", last_name: "some last_name", notes: "some notes"}
    @update_attrs %{first_name: "some updated first_name", last_name: "some updated last_name", notes: "some updated notes"}
    @invalid_attrs %{first_name: nil, last_name: nil, notes: nil}

    def student_fixture(attrs \\ %{}) do
      {:ok, student} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Directory.create_student()

      student |> Repo.preload([:bus, :class, :addresses])
    end

    test "paginate_students/1 returns paginated list of students" do
      for _ <- 1..20 do
        student_fixture()
      end

      {:ok, %{students: students} = page} = Directory.paginate_students(%{})

      assert length(students) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_students/0 returns all students" do
      student = student_fixture()
      assert Directory.list_students() == [student]
    end

    test "get_student!/1 returns the student with given id" do
      student = student_fixture()
      assert Directory.get_student!(student.id) == student
    end

    test "create_student/1 with valid data creates a student" do
      assert {:ok, %Student{} = student} = Directory.create_student(@valid_attrs)
      assert student.first_name == "some first_name"
      assert student.last_name == "some last_name"
      assert student.notes == "some notes"
    end

    test "create_student/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Directory.create_student(@invalid_attrs)
    end

    test "update_student/2 with valid data updates the student" do
      student = student_fixture()
      assert {:ok, student} = Directory.update_student(student, @update_attrs)
      assert %Student{} = student
      assert student.first_name == "some updated first_name"
      assert student.last_name == "some updated last_name"
      assert student.notes == "some updated notes"
    end

    test "update_student/2 with invalid data returns error changeset" do
      student = student_fixture()
      assert {:error, %Ecto.Changeset{}} = Directory.update_student(student, @invalid_attrs)
      assert student == Directory.get_student!(student.id)
    end

    test "delete_student/1 deletes the student" do
      student = student_fixture()
      assert {:ok, %Student{}} = Directory.delete_student(student)
      assert_raise Ecto.NoResultsError, fn -> Directory.get_student!(student.id) end
    end

    test "change_student/1 returns a student changeset" do
      student = student_fixture()
      assert %Ecto.Changeset{} = Directory.change_student(student)
    end
  end

  describe "adults" do
    alias StudentList.Directory.Adult

    @valid_attrs %{email: "some email", first_name: "some first_name", last_name: "some last_name", mobile_phone: "some mobile_phone"}
    @update_attrs %{email: "some updated email", first_name: "some updated first_name", last_name: "some updated last_name", mobile_phone: "some updated mobile_phone"}
    @invalid_attrs %{email: nil, first_name: nil, last_name: nil, mobile_phone: nil}

    def adult_fixture(attrs \\ %{}) do
      {:ok, adult} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Directory.create_adult()

      adult |> Repo.preload([:address])
    end

    test "paginate_adults/1 returns paginated list of adults" do
      for _ <- 1..20 do
        adult_fixture()
      end

      {:ok, %{adults: adults} = page} = Directory.paginate_adults(%{})

      assert length(adults) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_adults/0 returns all adults" do
      adult = adult_fixture()
      assert Directory.list_adults() == [adult]
    end

    test "get_adult!/1 returns the adult with given id" do
      adult = adult_fixture()
      assert Directory.get_adult!(adult.id) == adult
    end

    test "create_adult/1 with valid data creates a adult" do
      assert {:ok, %Adult{} = adult} = Directory.create_adult(@valid_attrs)
      assert adult.email == "some email"
      assert adult.first_name == "some first_name"
      assert adult.last_name == "some last_name"
      assert adult.mobile_phone == "some mobile_phone"
    end

    test "create_adult/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Directory.create_adult(@invalid_attrs)
    end

    test "update_adult/2 with valid data updates the adult" do
      adult = adult_fixture()
      assert {:ok, adult} = Directory.update_adult(adult, @update_attrs)
      assert %Adult{} = adult
      assert adult.email == "some updated email"
      assert adult.first_name == "some updated first_name"
      assert adult.last_name == "some updated last_name"
      assert adult.mobile_phone == "some updated mobile_phone"
    end

    test "update_adult/2 with invalid data returns error changeset" do
      adult = adult_fixture()
      assert {:error, %Ecto.Changeset{}} = Directory.update_adult(adult, @invalid_attrs)
      assert adult == Directory.get_adult!(adult.id)
    end

    test "delete_adult/1 deletes the adult" do
      adult = adult_fixture()
      assert {:ok, %Adult{}} = Directory.delete_adult(adult)
      assert_raise Ecto.NoResultsError, fn -> Directory.get_adult!(adult.id) end
    end

    test "change_adult/1 returns a adult changeset" do
      adult = adult_fixture()
      assert %Ecto.Changeset{} = Directory.change_adult(adult)
    end
  end

  describe "entries" do
    alias StudentList.Directory.Entry

    @valid_attrs %{content: "some content"}
    @update_attrs %{content: "some updated content"}
    @invalid_attrs %{content: nil}

    def entry_fixture(attrs \\ %{}) do
      {:ok, entry} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Directory.create_entry()

      entry |> Repo.preload([:students, :addresses])
    end

    test "paginate_entries/1 returns paginated list of entries" do
      for _ <- 1..20 do
        entry_fixture()
      end

      {:ok, %{entries: entries} = page} = Directory.paginate_entries(%{})

      assert length(entries) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_entries/0 returns all entries" do
      entry = entry_fixture()
      assert Directory.list_entries() == [entry]
    end

    test "get_entry!/1 returns the entry with given id" do
      entry = entry_fixture()
      assert Directory.get_entry!(entry.id) == entry
    end

    test "create_entry/1 with valid data creates a entry" do
      assert {:ok, %Entry{} = entry} = Directory.create_entry(@valid_attrs)
      assert entry.content == "some content"
    end

    test "create_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Directory.create_entry(@invalid_attrs)
    end

    test "update_entry/2 with valid data updates the entry" do
      entry = entry_fixture()
      assert {:ok, entry} = Directory.update_entry(entry, @update_attrs)
      assert %Entry{} = entry
      assert entry.content == "some updated content"
    end

    test "update_entry/2 with invalid data returns error changeset" do
      entry = entry_fixture()
      assert {:error, %Ecto.Changeset{}} = Directory.update_entry(entry, @invalid_attrs)
      assert entry == Directory.get_entry!(entry.id)
    end

    test "delete_entry/1 deletes the entry" do
      entry = entry_fixture()
      assert {:ok, %Entry{}} = Directory.delete_entry(entry)
      assert_raise Ecto.NoResultsError, fn -> Directory.get_entry!(entry.id) end
    end

    test "change_entry/1 returns a entry changeset" do
      entry = entry_fixture()
      assert %Ecto.Changeset{} = Directory.change_entry(entry)
    end
  end

  describe "email settings" do
    alias StudentList.Directory.Setting
      @test_email "test@example.com"

    test "no support email defined returns nil" do
      assert Directory.support_email() == nil
    end

    test "support email returned if defined" do
      Directory.create_setting(%{key: "support_email", value: @test_email})

      assert Directory.support_email() == @test_email
    end

    test "other setting does not return support email" do
      Directory.create_setting(%{key: "not_support_email", value: @test_email})

      assert Directory.support_email() == nil
    end
  end

  describe "settings" do
    alias StudentList.Directory.Setting

    @valid_attrs %{key: "some key", value: "some value"}
    @update_attrs %{key: "some updated key", value: "some updated value"}
    @invalid_attrs %{key: nil, value: nil}

    def setting_fixture(attrs \\ %{}) do
      {:ok, setting} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Directory.create_setting()

      setting
    end

    test "paginate_settings/1 returns paginated list of settings" do
      for _ <- 1..20 do
        setting_fixture()
      end

      {:ok, %{settings: settings} = page} = Directory.paginate_settings(%{})

      assert length(settings) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_settings/0 returns all settings" do
      setting = setting_fixture()
      assert Directory.list_settings() == [setting]
    end

    test "get_setting!/1 returns the setting with given id" do
      setting = setting_fixture()
      assert Directory.get_setting!(setting.id) == setting
    end

    test "create_setting/1 with valid data creates a setting" do
      assert {:ok, %Setting{} = setting} = Directory.create_setting(@valid_attrs)
      assert setting.key == "some key"
      assert setting.value == "some value"
    end

    test "create_setting/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Directory.create_setting(@invalid_attrs)
    end

    test "update_setting/2 with valid data updates the setting" do
      setting = setting_fixture()
      assert {:ok, setting} = Directory.update_setting(setting, @update_attrs)
      assert %Setting{} = setting
      assert setting.key == "some updated key"
      assert setting.value == "some updated value"
    end

    test "update_setting/2 with invalid data returns error changeset" do
      setting = setting_fixture()
      assert {:error, %Ecto.Changeset{}} = Directory.update_setting(setting, @invalid_attrs)
      assert setting == Directory.get_setting!(setting.id)
    end

    test "delete_setting/1 deletes the setting" do
      setting = setting_fixture()
      assert {:ok, %Setting{}} = Directory.delete_setting(setting)
      assert_raise Ecto.NoResultsError, fn -> Directory.get_setting!(setting.id) end
    end

    test "change_setting/1 returns a setting changeset" do
      setting = setting_fixture()
      assert %Ecto.Changeset{} = Directory.change_setting(setting)
    end
  end
end
