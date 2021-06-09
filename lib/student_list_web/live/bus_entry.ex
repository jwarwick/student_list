defmodule StudentListWeb.Live.BusEntry do
  use Surface.LiveComponent
  alias Surface.Components.Form.{Field, Label, Select}
  alias StudentList.Directory

  data buses, :map

  def mount(socket) do
    {:ok, assign(socket, buses: Directory.sorted_buses())}
  end

  def render(assigns) do
    ~H"""
    <Field name="bus">
      <Label>Bus</Label>
      <div class="select">
        <Select options={{ @buses }} />
      </div>
    </Field>
    """
  end
end
