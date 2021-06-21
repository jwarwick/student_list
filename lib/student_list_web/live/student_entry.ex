defmodule StudentListWeb.Live.StudentEntry do
  use Surface.LiveComponent

  alias Surface.Components.{Form, Link}
  alias Surface.Components.Form.{Field, Label, TextInput, Select}

  prop can_delete, :boolean, default: true
  prop index, :integer
  prop student, :map
  prop sorted_buses, :list
  prop sorted_classrooms, :list

  defp first_value([{_key, v} | _rest]), do: v
  defp first_value(_), do: nil

  @impl true
  def render(assigns) do
    ~F"""
      <div class="card mb-4">
        <div class="card-header">
          <div class="card-header-title">
            Student
          </div>
        </div>

        <div class="card-content">
          <Form for={:student} change="update_student" >
            <Field class="field" name="first_name">
              <Label class="label">First Name</Label>
              <div class="control">
                <TextInput class="input" value={Map.get(@student, "first_name", "")} id={"#{assigns.id}-first-name"} />
              </div>
            </Field>

            <Field class="field" name="last_name">
              <Label class="label">Last Name</Label>
              <div class="control">
                <TextInput class="input" value={Map.get(@student, "last_name", "")} id={"#{assigns.id}-last-name"} />
              </div>
            </Field>

            <Field class="field" name={:classroom}>
              <Label class="label">Classroom</Label>
              <div class="select">
                <Select class="input" options={@sorted_classrooms} id={"#{assigns.id}-classroom"} selected={Map.get(@student, "classroom", first_value(@sorted_classrooms))}/>
              </div>
            </Field>

            <Field class="field" name={:bus}>
              <Label class="label">Bus</Label>
              <div class="select">
                <Select class="input" options={@sorted_buses} id={"#{assigns.id}-bus"} selected={Map.get(@student, "bus", first_value(@sorted_buses))}/>
              </div>
            </Field>

            </Form>
        </div>

        <div>
          <footer class="card-footer" :if={@can_delete}>
            <div class="card-footer-item card-remove-button">
              <button type="button" class="button is-small is-danger is-light" :on-click="delete_student">Remove Student</button>
              </div>
          </footer>
        </div>
      </div>
    """
  end

  @impl true
  def handle_event("update_student", %{"student" => params}, socket) do
    send(self(), {:update_student, socket.assigns.index, params})
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete_student", _params, socket) do
    send(self(), {:delete_student, socket.assigns.index})
    {:noreply, socket}
  end
end
