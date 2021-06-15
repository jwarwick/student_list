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
    ~H"""
      <div>
      <Form for={{:student}} change="change_student" >
        <Field name="first_name">
          <Label>First Name</Label>
          <div class="control">
            <TextInput value={{ Map.get(@student, "first_name", "") }} id="{{assigns.id}}-first-name" />
          </div>
        </Field>

        <Field name="last_name">
          <Label>Last Name</Label>
          <div class="control">
            <TextInput value={{ Map.get(@student, "last_name", "") }} id="{{assigns.id}}-last-name" />
          </div>
        </Field>

        <Field name={{:classroom}}>
          <Label>Classroom</Label>
          <div class="select">
            <Select options={{ @sorted_classrooms }} id="{{assigns.id}}-classroom" selected={{ Map.get(@student, "classroom", first_value(@sorted_classrooms)) }}/>
          </div>
        </Field>

        <Field name={{:bus}}>
          <Label>Bus</Label>
          <div class="select">
            <Select options={{ @sorted_buses }} id="{{assigns.id}}-bus" selected={{ Map.get(@student, "bus", first_value(@sorted_buses)) }}/>
          </div>
        </Field>

        </Form>

        <Link :if={{@can_delete}} label="Remove Student" to="#" click="delete_student" />
      </div>
    """
  end

  @impl true
  def handle_event("change_student", %{"student" => params}, socket) do
    send(self(), {:update_student, socket.assigns.index, params})
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete_student", _params, socket) do
    send(self(), {:delete_student, socket.assigns.index})
    {:noreply, socket}
  end
end
