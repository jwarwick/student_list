defmodule StudentListWeb.PageLive do
  use Surface.LiveView

  alias StudentList.Repo
  alias Ecto.Multi

  alias StudentList.Directory
  alias StudentList.Directory.{Address, Student}

  alias StudentListWeb.Live.{Heading, StudentEntry, AddressEntry}

  data submitted, :boolean, default: false
  data students, :list, default: [%{}]
  data addresses, :list, default: [%{adults: [%{}]}]

  prop sorted_buses, :list
  prop sorted_classrooms, :list

  @impl true
  def mount(_params, _session, socket) do
    socket = socket
             |> assign(sorted_classrooms: Directory.sorted_classrooms())
             |> assign(sorted_buses: Directory.sorted_buses())
    {:ok, socket}
  end

  defp valid_data?(assigns) do
    Enum.all?(assigns.students, fn s -> Map.get(s, "first_name", "") != "" end)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div :if={{@submitted}}>
     <h1>Thanks for entering your info!</h1>
    </div>
    <div :if={{!@submitted}}>
      <Heading />

      <section>
        <div class="student_list">
        <StudentEntry
          :for.with_index={{ {s, index} <- @students}}
            id="student-{{index}}"
            student={{s}}
            index={{index}}
            sorted_buses={{@sorted_buses}}
            sorted_classrooms={{@sorted_classrooms}}
            can_delete={{ length(@students) > 1 }} />
        </div>
        <button type="button" class="button is-info is-small" :on-click="add_student">Add Another Student</button>
      </section>

      <section>
        <div class="address_list">
        <AddressEntry
          :for.with_index={{ {a, index} <- @addresses}}
            id="address-{{index}}"
            address={{a}}
            index={{index}}
            can_delete={{ length(@addresses) > 1 }} />
        </div>
        <button type="button" class="button is-info is-small" :on-click="add_address">Add Another Household</button>
      </section>

      <button type="button" class="button is-info is-large" :on-click="submit_form" disabled={{!valid_data?(assigns)}} >Submit</button>
    </div>
    """
  end

  @impl true
  def handle_event("add_student", _value, socket) do
    students = socket.assigns.students ++ [%{}]
    socket = assign(socket, students: students)
    {:noreply, socket}
  end

  @impl true
  def handle_event("add_address", _value, socket) do
    addresses = socket.assigns.addresses ++ [%{adults: [%{}]}]
    socket = assign(socket, addresses: addresses)
    {:noreply, socket}
  end

  @impl true
  def handle_event("submit_form", _value, socket) do
    multi = Enum.reduce(Enum.with_index(socket.assigns.students),
                                        Multi.new(),
                                        fn ({x, idx}, acc) -> Multi.insert(acc, "student #{idx}", Student.creation_changeset(x)) end)
    multi = Enum.reduce(Enum.with_index(socket.assigns.addresses),
                                        multi,
                                        fn ({x, idx}, acc) -> Multi.insert(acc, "address #{idx}", Address.creation_changeset(x)) end)
    _result = Repo.transaction(multi)

    socket = assign(socket, submitted: true)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:delete_student, index}, socket) do
    students = List.delete_at(socket.assigns.students, index)
    {:noreply, assign(socket, students: students)}
  end

  @impl true
  def handle_info({:update_student, index, params}, socket) do
    students = List.replace_at(socket.assigns.students, index, params)
    {:noreply, assign(socket, students: students)}
  end

  @impl true
  def handle_info({:delete_address, index}, socket) do
    addresses = List.delete_at(socket.assigns.addresses, index)
    {:noreply, assign(socket, addresses: addresses)}
  end

  @impl true
  def handle_info({:update_address, index, params}, socket) do
    IO.inspect(socket.assigns.addresses, label: "current address")
    IO.inspect(params, label: "update address")
    addresses = List.replace_at(socket.assigns.addresses, index, params)
    # {:noreply, assign(socket, addresses: addresses)}
    {:noreply, socket}
  end

  @impl true
  def handle_info({:add_adult, index}, socket) do
    address = Enum.at(socket.assigns.addresses, index)
    adults = address.adults ++ [%{}]
    address = %{address | adults: adults}
    addresses = List.replace_at(socket.assigns.addresses, index, address)
    {:noreply, assign(socket, addresses: addresses)}
  end

  @impl true
  def handle_info({:delete_adult, address_index, index}, socket) do
    address = Enum.at(socket.assigns.addresses, address_index)
    adults = List.delete_at(address.adults, index)
    address = %{address | adults: adults}
    addresses = List.replace_at(socket.assigns.addresses, address_index, address)
    {:noreply, assign(socket, addresses: addresses)}
  end

  @impl true
  def handle_info({:update_adult, address_index, index, params}, socket) do
    address = Enum.at(socket.assigns.addresses, address_index)
    adults = List.replace_at(address.adults, index, params)
    address = %{address | adults: adults}
    addresses = List.replace_at(socket.assigns.addresses, address_index, address)
    {:noreply, assign(socket, addresses: addresses)}
  end
end
