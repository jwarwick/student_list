defmodule StudentListWeb.Live.AdultEntry do
  use Surface.LiveComponent

  alias Surface.Components.{Form, Link}
  alias Surface.Components.Form.{Field, Label, TextInput}

  prop can_delete, :boolean, default: true
  prop index, :integer
  prop address_index, :integer
  prop adult, :map

  @impl true
  def render(assigns) do
    ~F"""
      <div>
      <Form for={:adult} change="update_adult" >

        <Field name="first_name">
          <Label>First Name</Label>
          <div class="control">
            <TextInput value={Map.get(@adult, "first_name", "")} id={"#{assigns.id}-first-name"} />
          </div>
        </Field>

        <Field name="last_name">
          <Label>Last Name</Label>
          <div class="control">
            <TextInput value={Map.get(@adult, "last_name", "")} id={"#{assigns.id}-last-name"} />
          </div>
        </Field>

        <Field name="email">
          <Label>Email</Label>
          <div class="control">
            <TextInput value={Map.get(@adult, "email", "")} id={"#{assigns.id}-email"} />
          </div>
        </Field>

        <Field name="mobile_phone">
          <Label>Mobile Phone</Label>
          <div class="control">
            <TextInput value={Map.get(@adult, "mobile_phone", "")} id={"#{assigns.id}-mobile-phone"} />
          </div>
        </Field>
      </Form>

        <Link :if={@can_delete} label="Remove Adult" to="#" click="delete_adult" />
      </div>
    """
  end

  @impl true
  def handle_event("delete_adult", _params, socket) do
    send(self(), {:delete_adult, socket.assigns.address_index, socket.assigns.index})
    {:noreply, socket}
  end

  @impl true
  def handle_event("update_adult", %{"adult" => params}, socket) do
    send(self(), {:update_adult, socket.assigns.address_index, socket.assigns.index, params})
    {:noreply, socket}
  end
end
