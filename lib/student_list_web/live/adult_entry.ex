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
      <div class="card mb-4">
        <div class="card-header">
          <div class="card-header-title">
            Adult
          </div>
        </div>

        <div class="card-content">
          <Form for={:adult} change="update_adult" >

            <Field class="field" name="first_name">
              <Label class="label">First Name</Label>
              <div class="control">
                <TextInput class="input" value={Map.get(@adult, "first_name", "")} id={"#{assigns.id}-first-name"} />
              </div>
            </Field>

            <Field class="field" name="last_name">
              <Label class="label">Last Name</Label>
              <div class="control">
                <TextInput class="input" value={Map.get(@adult, "last_name", "")} id={"#{assigns.id}-last-name"} />
              </div>
            </Field>

            <Field class="field" name="email">
              <Label class="label">Email</Label>
              <div class="control">
                <TextInput class="input" value={Map.get(@adult, "email", "")} id={"#{assigns.id}-email"} />
              </div>
            </Field>

            <Field class="field" name="mobile_phone">
              <Label class="label">Mobile Phone</Label>
              <div class="control">
                <TextInput class="input" value={Map.get(@adult, "mobile_phone", "")} id={"#{assigns.id}-mobile-phone"} />
              </div>
            </Field>
          </Form>
        </div>

        <div>
          <footer class="card-footer" :if={@can_delete}>
            <div class="card-footer-item card-remove-button">
              <button type="button" class="button is-small is-danger is-light" :on-click="delete_adult">Remove Adult</button>
              </div>
          </footer>
        </div>
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
