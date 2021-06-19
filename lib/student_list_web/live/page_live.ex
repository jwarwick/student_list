defmodule StudentListWeb.PageLive do
  use Surface.LiveView

  alias Surface.Components.Form
  alias Surface.Components.Form.{Field, Label, TextArea}

  alias Ecto.Multi

  alias StudentList.Repo
  alias StudentList.Directory
  alias StudentList.Directory.{Address, Student}

  alias StudentListWeb.Live.{Heading, StudentEntry, AddressEntry}

  data submitted, :boolean, default: false
  data students, :list, default: [%{}]
  data addresses, :list, default: [%{"adults" => [%{}]}]
  data notes, :string, default: ""

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
    ~F"""
    <div :if={@submitted}>
     <h1>Thanks for entering your info!</h1>
    </div>
    <div :if={!@submitted}>
      <Heading />

      <section class="students">
        <div class="student_list">
        <StudentEntry
          :for.with_index={{s, index} <- @students}
            id={"student-#{index}"}
            student={s}
            index={index}
            sorted_buses={@sorted_buses}
            sorted_classrooms={@sorted_classrooms}
            can_delete={length(@students) > 1} />
        </div>
        <button type="button" class="button is-info is-small" :on-click="add_student">Add Another Student</button>
      </section>

      <section class="addresses">
        <div class="address_list">
        <AddressEntry
          :for.with_index={{a, index} <- @addresses}
            id={"address-#{index}"}
            address={a}
            index={index}
            can_delete={length(@addresses) > 1} />
        </div>
        <button type="button" class="button is-info is-small" :on-click="add_address">Add Another Household</button>
      </section>

      <section class="notes">
        <Form for={:notes} change="update_notes" >
          <Field name="note">
            <Label>Notes</Label>
            <div class="control">
              <TextArea rows={"4"} value={@notes} id={"notes-input"} opts={placeholder: "Anything you want the fine folks compiling the directory to know. Tell us if you are on the PTO, a classroom representative, on the School Committee, on the School Council, or on the Safety Committee."} />
            </div>
          </Field>
        </Form>
      </section>

      <button type="button" class="button is-info is-large" :on-click="submit_form" disabled={!valid_data?(assigns)} >Submit</button>
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
    addresses = socket.assigns.addresses ++ [%{"adults" => [%{}]}]
    socket = assign(socket, addresses: addresses)
    {:noreply, socket}
  end

  @impl true
  def handle_event("update_notes", %{"notes" => %{"note" => note}}, socket) do
    socket = assign(socket, notes: note)
    {:noreply, socket}
  end

  @impl true
  def handle_event("submit_form", _value, socket) do
    students_notes = Enum.map(socket.assigns.students, &(Map.put(&1, "notes", socket.assigns.notes)))

    multi = Multi.new()
    multi = Enum.reduce(Enum.with_index(students_notes),
                                        multi,
                                        fn ({x, idx}, acc) -> Student.creation_transaction(acc, idx, x) end)
    multi = Enum.reduce(Enum.with_index(socket.assigns.addresses),
                                        multi,
                                        fn ({x, idx}, acc) -> Address.creation_transaction(acc, idx, x) end)
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
    curr = Enum.at(socket.assigns.addresses, index)
    new_addr = Map.merge(curr, params)
    addresses = List.replace_at(socket.assigns.addresses, index, new_addr)
    {:noreply, assign(socket, addresses: addresses)}
  end

  @impl true
  def handle_info({:add_adult, index}, socket) do
    address = Enum.at(socket.assigns.addresses, index)
    adults = address["adults"] ++ [%{}]
    address = %{address | "adults" => adults}
    addresses = List.replace_at(socket.assigns.addresses, index, address)
    {:noreply, assign(socket, addresses: addresses)}
  end

  @impl true
  def handle_info({:delete_adult, address_index, index}, socket) do
    address = Enum.at(socket.assigns.addresses, address_index)
    adults = List.delete_at(address["adults"], index)
    address = %{address | "adults" => adults}
    addresses = List.replace_at(socket.assigns.addresses, address_index, address)
    {:noreply, assign(socket, addresses: addresses)}
  end

  @impl true
  def handle_info({:update_adult, address_index, index, params}, socket) do
    address = Enum.at(socket.assigns.addresses, address_index)
    adults = List.replace_at(address["adults"], index, params)
    address = %{address | "adults" => adults}
    addresses = List.replace_at(socket.assigns.addresses, address_index, address)
    {:noreply, assign(socket, addresses: addresses)}
  end
end
