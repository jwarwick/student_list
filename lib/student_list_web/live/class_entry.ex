defmodule StudentListWeb.Live.ClassEntry do
  use Surface.LiveComponent
  alias Surface.Components.Form.{Field, Label, Select}
  alias StudentList.Directory

  data classes, :map

  def mount(socket) do
    {:ok, assign(socket, classes: Directory.sorted_classes())}
  end

  def render(assigns) do
    ~H"""
    <Field name="classroom">
      <Label>Classroom</Label>
      <div class="select">
        <Select options={{ @classes }} />
      </div>
    </Field>
    """
  end
end
