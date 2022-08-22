defmodule StudentList.Directory do
  @moduledoc """
  The Directory context.
  """

  import Ecto.Query, warn: false
  alias StudentList.Repo

  import Torch.Helpers, only: [sort: 1, paginate: 4]
  import Filtrex.Type.Config

  alias StudentList.Accounts.{Email, Mailer}

  alias StudentList.Directory.Bus
  alias StudentList.Directory.Class
  alias StudentList.Directory.Address
  alias StudentList.Directory.Student
  alias StudentList.Directory.Adult
  alias StudentList.Directory.Entry
  alias StudentList.Directory.Setting

  @pagination [page_size: 15]
  @pagination_distance 5

  @doc """
  Get a keyword list of buses sorted by `display_order`.
  """
  def sorted_buses do
    query = from b in Bus, order_by: b.display_order, select: {b.name, b.id}
    Repo.all(query)
    |> Keyword.new(fn {a, b} -> {String.to_atom(a), b} end)
  end

  @doc """
  Get a keyword list of classes sorted by `display_order`.
  """
  def sorted_classrooms do
    query = from c in Class, order_by: c.display_order, select: {c.name, c.id}
    Repo.all(query)
    |> Keyword.new(fn {a, b} -> {String.to_atom(a), b} end)
  end

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
  defp filter_config(:classes) do
    defconfig do
      text :name
      text :teacher
      number :display_order

    end
  end
  defp filter_config(:addresses) do
    defconfig do
      text :address1
      text :address2
      text :city
      text :state
      text :zip
      text :phone

    end
  end
  defp filter_config(:students) do
    defconfig do
      text :first_name
      text :last_name
      text :notes
    end
  end

  defp filter_config(:adults) do
    defconfig do
      text :first_name
      text :last_name
      text :email
      text :mobile_phone

    end
  end

  defp filter_config(:entries) do
    defconfig do
      text :content

    end
  end

  defp filter_config(:settings) do
    defconfig do
      text :key
      text :value

    end
  end

  @doc """
  Paginate the list of classes using filtrex
  filters.

  ## Examples

  iex> list_classes(%{})
  %{classes: [%Class{}], ...}
  """
  @spec paginate_classes(map) :: {:ok, map} | {:error, any}
  def paginate_classes(params \\ %{}) do
    params =
      params
      |> Map.put_new("sort_direction", "desc")
      |> Map.put_new("sort_field", "inserted_at")

    {:ok, sort_direction} = Map.fetch(params, "sort_direction")
    {:ok, sort_field} = Map.fetch(params, "sort_field")

    with {:ok, filter} <- Filtrex.parse_params(filter_config(:classes), params["class"] || %{}),
         %Scrivener.Page{} = page <- do_paginate_classes(filter, params) do
           {:ok,
             %{
               classes: page.entries,
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

  defp do_paginate_classes(filter, params) do
    Class
    |> Filtrex.query(filter)
    |> order_by(^sort(params))
    |> paginate(Repo, params, @pagination)
  end

  @doc """
  Returns the list of classes.

  ## Examples

  iex> list_classes()
  [%Class{}, ...]

  """
  def list_classes do
    Repo.all(from c in Class, order_by: c.display_order)
  end

  @doc """
  Gets a single class.

  Raises `Ecto.NoResultsError` if the Class does not exist.

  ## Examples

  iex> get_class!(123)
  %Class{}

  iex> get_class!(456)
  ** (Ecto.NoResultsError)

  """
  def get_class!(id), do: Repo.get!(Class, id)

  @doc """
  Creates a class.

  ## Examples

  iex> create_class(%{field: value})
  {:ok, %Class{}}

  iex> create_class(%{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def create_class(attrs \\ %{}) do
    %Class{}
    |> Class.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a class.

  ## Examples

  iex> update_class(class, %{field: new_value})
  {:ok, %Class{}}

  iex> update_class(class, %{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def update_class(%Class{} = class, attrs) do
    class
    |> Class.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Class.

  ## Examples

  iex> delete_class(class)
  {:ok, %Class{}}

  iex> delete_class(class)
  {:error, %Ecto.Changeset{}}

  """
  def delete_class(%Class{} = class) do
    Repo.delete(class)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking class changes.

  ## Examples

  iex> change_class(class)
  %Ecto.Changeset{source: %Class{}}

  """
  def change_class(%Class{} = class, attrs \\ %{}) do
    Class.changeset(class, attrs)
  end



  @doc """
  Paginate the list of addresses using filtrex
  filters.

  ## Examples

  iex> list_addresses(%{})
  %{addresses: [%Address{}], ...}
  """
  @spec paginate_addresses(map) :: {:ok, map} | {:error, any}
  def paginate_addresses(params \\ %{}) do
    params =
      params
      |> Map.put_new("sort_direction", "desc")
      |> Map.put_new("sort_field", "inserted_at")

    {:ok, sort_direction} = Map.fetch(params, "sort_direction")
    {:ok, sort_field} = Map.fetch(params, "sort_field")

    with {:ok, filter} <- Filtrex.parse_params(filter_config(:addresses), params["address"] || %{}),
         %Scrivener.Page{} = page <- do_paginate_addresses(filter, params) do
           {:ok,
             %{
               addresses: page.entries,
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

  defp do_paginate_addresses(filter, params) do
    Address
    |> Filtrex.query(filter)
    |> order_by(^sort(params))
    |> paginate(Repo, params, @pagination)
  end

  @doc """
  Returns the list of addresses.

  ## Examples

  iex> list_addresses()
  [%Address{}, ...]

  """
  def list_addresses do
    Repo.all(Address) |> Repo.preload([:adults, :students])
  end

  @doc """
  Gets a single address.

  Raises `Ecto.NoResultsError` if the Address does not exist.

  ## Examples

  iex> get_address!(123)
  %Address{}

  iex> get_address!(456)
  ** (Ecto.NoResultsError)

  """
  def get_address!(id), do: Repo.get!(Address, id) |> Repo.preload([:adults, :students])

  @doc """
  Creates a address.

  ## Examples

  iex> create_address(%{field: value})
  {:ok, %Address{}}

  iex> create_address(%{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def create_address(attrs \\ %{}) do
    %Address{}
    |> Address.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a address.

  ## Examples

  iex> update_address(address, %{field: new_value})
  {:ok, %Address{}}

  iex> update_address(address, %{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def update_address(%Address{} = address, attrs) do
    address
    |> Address.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Address.

  ## Examples

  iex> delete_address(address)
  {:ok, %Address{}}

  iex> delete_address(address)
  {:error, %Ecto.Changeset{}}

  """
  def delete_address(%Address{} = address) do
    Repo.delete(address)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking address changes.

  ## Examples

  iex> change_address(address)
  %Ecto.Changeset{source: %Address{}}

  """
  def change_address(%Address{} = address, attrs \\ %{}) do
    Address.changeset(address, attrs)
  end



  @doc """
  Paginate the list of students using filtrex
  filters.

  ## Examples

  iex> list_students(%{})
  %{students: [%Student{}], ...}
  """
  @spec paginate_students(map) :: {:ok, map} | {:error, any}
  def paginate_students(params \\ %{}) do
    params =
      params
      |> Map.put_new("sort_direction", "desc")
      |> Map.put_new("sort_field", "inserted_at")

    {:ok, sort_direction} = Map.fetch(params, "sort_direction")
    {:ok, sort_field} = Map.fetch(params, "sort_field")

    with {:ok, filter} <- Filtrex.parse_params(filter_config(:students), params["student"] || %{}),
         %Scrivener.Page{} = page <- do_paginate_students(filter, params) do
           {:ok,
             %{
               students: page.entries,
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

  defp do_paginate_students(filter, params) do
    Student
    |> Filtrex.query(filter)
    |> order_by(^sort(params))
    |> preload([:bus, :class])
    |> paginate(Repo, params, @pagination)
  end

  @doc """
  Returns the list of students.

  ## Examples

  iex> list_students()
  [%Student{}, ...]

  """
  def list_students do
    Repo.all(Student) |> Repo.preload([:bus, :class, :addresses])
  end

  @doc """
  Gets a single student.

  Raises `Ecto.NoResultsError` if the Student does not exist.

  ## Examples

  iex> get_student!(123)
  %Student{}

  iex> get_student!(456)
  ** (Ecto.NoResultsError)

  """
  def get_student!(id), do: Repo.get!(Student, id) |> Repo.preload([:bus, :class, addresses: [:adults]])

  @doc """
  Creates a student.

  ## Examples

  iex> create_student(%{field: value})
  {:ok, %Student{}}

  iex> create_student(%{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def create_student(attrs \\ %{}) do
    %Student{}
    |> Student.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a student.

  ## Examples

  iex> update_student(student, %{field: new_value})
  {:ok, %Student{}}

  iex> update_student(student, %{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def update_student(%Student{} = student, attrs) do
    student
    |> Student.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Student.

  ## Examples

  iex> delete_student(student)
  {:ok, %Student{}}

  iex> delete_student(student)
  {:error, %Ecto.Changeset{}}

  """
  def delete_student(%Student{} = student) do
    Repo.delete(student)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking student changes.

  ## Examples

  iex> change_student(student)
  %Ecto.Changeset{source: %Student{}}

  """
  def change_student(%Student{} = student, attrs \\ %{}) do
    Student.changeset(student, attrs)
  end




  @doc """
  Paginate the list of adults using filtrex
  filters.

  ## Examples

  iex> list_adults(%{})
  %{adults: [%Adult{}], ...}
  """
  @spec paginate_adults(map) :: {:ok, map} | {:error, any}
  def paginate_adults(params \\ %{}) do
    params =
      params
      |> Map.put_new("sort_direction", "desc")
      |> Map.put_new("sort_field", "inserted_at")

    {:ok, sort_direction} = Map.fetch(params, "sort_direction")
    {:ok, sort_field} = Map.fetch(params, "sort_field")

    with {:ok, filter} <- Filtrex.parse_params(filter_config(:adults), params["adult"] || %{}),
         %Scrivener.Page{} = page <- do_paginate_adults(filter, params) do
           {:ok,
             %{
               adults: page.entries,
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

  defp do_paginate_adults(filter, params) do
    Adult
    |> Filtrex.query(filter)
    |> order_by(^sort(params))
    |> preload([:address])
    |> paginate(Repo, params, @pagination)
  end

  @doc """
  Returns the list of adults.

  ## Examples

  iex> list_adults()
  [%Adult{}, ...]

  """
  def list_adults do
    Repo.all(Adult) |> Repo.preload([:address])
  end

  @doc """
  Gets a single adult.

  Raises `Ecto.NoResultsError` if the Adult does not exist.

  ## Examples

  iex> get_adult!(123)
  %Adult{}

  iex> get_adult!(456)
  ** (Ecto.NoResultsError)

  """
  def get_adult!(id), do: Repo.get!(Adult, id) |> Repo.preload([:address])

  @doc """
  Creates a adult.

  ## Examples

  iex> create_adult(%{field: value})
  {:ok, %Adult{}}

  iex> create_adult(%{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def create_adult(attrs \\ %{}) do
    %Adult{}
    |> Adult.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a adult.

  ## Examples

  iex> update_adult(adult, %{field: new_value})
  {:ok, %Adult{}}

  iex> update_adult(adult, %{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def update_adult(%Adult{} = adult, attrs) do
    adult
    |> Adult.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Adult.

  ## Examples

  iex> delete_adult(adult)
  {:ok, %Adult{}}

  iex> delete_adult(adult)
  {:error, %Ecto.Changeset{}}

  """
  def delete_adult(%Adult{} = adult) do
    Repo.delete(adult)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking adult changes.

  ## Examples

  iex> change_adult(adult)
  %Ecto.Changeset{source: %Adult{}}

  """
  def change_adult(%Adult{} = adult, attrs \\ %{}) do
    Adult.changeset(adult, attrs)
  end



  @doc """
  Paginate the list of entries using filtrex
  filters.

  ## Examples

  iex> list_entries(%{})
  %{entries: [%Entry{}], ...}
  """
  @spec paginate_entries(map) :: {:ok, map} | {:error, any}
  def paginate_entries(params \\ %{}) do
    params =
      params
      |> Map.put_new("sort_direction", "desc")
      |> Map.put_new("sort_field", "inserted_at")

    {:ok, sort_direction} = Map.fetch(params, "sort_direction")
    {:ok, sort_field} = Map.fetch(params, "sort_field")

    with {:ok, filter} <- Filtrex.parse_params(filter_config(:entries), params["entry"] || %{}),
         %Scrivener.Page{} = page <- do_paginate_entries(filter, params) do
           {:ok,
             %{
               entries: page.entries,
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

  defp do_paginate_entries(filter, params) do
    Entry
    |> Filtrex.query(filter)
    |> order_by(^sort(params))
    |> paginate(Repo, params, @pagination)
  end

  @doc """
  Returns the list of entries.

  ## Examples

  iex> list_entries()
  [%Entry{}, ...]

  """
  def list_entries do
    Repo.all(Entry) |> Repo.preload([:students, :addresses])
  end

  @doc """
  Gets a single entry.

  Raises `Ecto.NoResultsError` if the Entry does not exist.

  ## Examples

  iex> get_entry!(123)
  %Entry{}

  iex> get_entry!(456)
  ** (Ecto.NoResultsError)

  """
  def get_entry!(id), do: Repo.get!(Entry, id) |> Repo.preload([:students, :addresses])

  @doc """
  Creates a entry.

  ## Examples

  iex> create_entry(%{field: value})
  {:ok, %Entry{}}

  iex> create_entry(%{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def create_entry(attrs \\ %{}) do
    %Entry{}
    |> Entry.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a Entry.

  ## Examples

  iex> delete_entry(entry)
  {:ok, %Entry{}}

  iex> delete_entry(entry)
  {:error, %Ecto.Changeset{}}

  """
  def delete_entry(%Entry{} = entry) do
    Repo.delete(entry)
  end

  @doc """
  Email a copy of the submitted form data to the support email
  """
  def email_entry(assigns) do
    Email.email_entry(assigns)
    |> Mailer.deliver_later()
  end

  @doc """
  Return the complete directory listing
  """
  def get_listing do
    #list_classes() |> Repo.preload([students: [:bus, addresses: :adults]])

    #Repo.all(from c in Class, order_by: c.display_order)

    query =
      from(
        c in Class,
        select: c,
        order_by: c.display_order,
        preload: [
          students:
            ^from(
              s in Student,
              order_by: [asc: s.last_name, asc: s.first_name],
              preload: [:bus, addresses: :adults]
            )
        ]
      )
    Repo.all(query)
  end

  @doc """
  Paginate the list of settings using filtrex
  filters.

  ## Examples

  iex> list_settings(%{})
  %{settings: [%Setting{}], ...}
  """
  @spec paginate_settings(map) :: {:ok, map} | {:error, any}
  def paginate_settings(params \\ %{}) do
    params =
      params
      |> Map.put_new("sort_direction", "desc")
      |> Map.put_new("sort_field", "inserted_at")

    {:ok, sort_direction} = Map.fetch(params, "sort_direction")
    {:ok, sort_field} = Map.fetch(params, "sort_field")

    with {:ok, filter} <- Filtrex.parse_params(filter_config(:settings), params["setting"] || %{}),
         %Scrivener.Page{} = page <- do_paginate_settings(filter, params) do
           {:ok,
             %{
               settings: page.entries,
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

  defp do_paginate_settings(filter, params) do
    Setting
    |> Filtrex.query(filter)
    |> order_by(^sort(params))
    |> paginate(Repo, params, @pagination)
  end

  @doc """
  Returns the list of settings.

  ## Examples

  iex> list_settings()
  [%Setting{}, ...]

  """
  def list_settings do
    Repo.all(Setting)
  end

  @doc """
  Gets a single setting.

  Raises `Ecto.NoResultsError` if the Setting does not exist.

  ## Examples

  iex> get_setting!(123)
  %Setting{}

  iex> get_setting!(456)
  ** (Ecto.NoResultsError)

  """
  def get_setting!(id), do: Repo.get!(Setting, id)

  @doc """
  Creates a setting.

  ## Examples

  iex> create_setting(%{field: value})
  {:ok, %Setting{}}

  iex> create_setting(%{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def create_setting(attrs \\ %{}) do
    %Setting{}
    |> Setting.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a setting.

  ## Examples

  iex> update_setting(setting, %{field: new_value})
  {:ok, %Setting{}}

  iex> update_setting(setting, %{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def update_setting(%Setting{} = setting, attrs) do
    setting
    |> Setting.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Setting.

  ## Examples

  iex> delete_setting(setting)
  {:ok, %Setting{}}

  iex> delete_setting(setting)
  {:error, %Ecto.Changeset{}}

  """
  def delete_setting(%Setting{} = setting) do
    Repo.delete(setting)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking setting changes.

  ## Examples

  iex> change_setting(setting)
  %Ecto.Changeset{source: %Setting{}}

  """
  def change_setting(%Setting{} = setting, attrs \\ %{}) do
    Setting.changeset(setting, attrs)
  end

  @doc """
  Get the support_email configuration
  """
  def support_email do
    case Repo.get_by(Setting, key: "support_email") do
      %Setting{value: value} -> value
      _ -> nil
    end
  end
end
