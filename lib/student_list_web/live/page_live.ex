defmodule StudentListWeb.PageLive do
  use Surface.LiveView

  alias StudentList.Repo
  alias Ecto.Multi

  alias StudentList.Directory
  alias StudentList.Directory.Student

  alias StudentListWeb.Live.{Heading, StudentEntry}

  data submitted, :boolean, default: false
  data students, :list, default: [%{}]
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
        <button class="button is-info is-small" :on-click="add_student">Add Another Student</button>
      </section>

      <button class="button is-info is-large" :on-click="submit_form" disabled={{!valid_data?(assigns)}} >Submit</button>
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
  def handle_event("submit_form", _value, socket) do
    multi = Enum.reduce(Enum.with_index(socket.assigns.students),
                                        Multi.new(),
                                        fn ({x, idx}, acc) -> Multi.insert(acc, "student #{idx}", Student.creation_changeset(x)) end)
    result = Repo.transaction(multi)
    IO.inspect(result)

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
end
