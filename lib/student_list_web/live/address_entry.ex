defmodule StudentListWeb.Live.AddressEntry do
  @moduledoc """
  Address entry component - holds adults and addresses
  """
  use Surface.LiveComponent

  alias Surface.Components.Form
  alias Surface.Components.Form.{Field, Label, TextInput}

  alias StudentListWeb.Live.AdultEntry

  prop can_delete, :boolean, default: true
  prop index, :integer
  prop address, :map

  @impl true
  def render(assigns) do
    ~F"""

      <div class="card mb-4">
        <div class="card-header address-card-header">
          <div class="card-header-title">
            Household
          </div>
        </div>
        <div class="card-content">
         <div class="adults mb-6">
          <div class="container">
            <div class="mb-4">
              <AdultEntry
                :for.with_index={{a, adult_index} <- @address["adults"]}
                  id={"adult-#{@index}-#{adult_index}"}
                  adult={a}
                  index={adult_index}
                  address_index={@index}
                  can_delete={length(@address["adults"]) > 1} />
             </div>
        
            <button type="button" class="button is-info" :on-click="add_adult">Add Another Adult</button>
          </div>
         </div>

      <Form for={:address} change="update_address" >
        <Field class="field" name="address1">
          <Label class="label">Address 1</Label>
          <div class="control">
            <TextInput class="input" value={Map.get(@address, "address1", "")} id={"#{assigns.id}-address-1"} />
          </div>
        </Field>

        <Field class="field" name="address2">
          <Label class="label">Address 2</Label>
          <div class="control">
            <TextInput class="input" value={Map.get(@address, "address2", "")} id={"#{assigns.id}-address-2"} />
          </div>
        </Field>

        <Field class="field" name="city">
          <Label class="label">City</Label>
          <div class="control">
            <TextInput class="input" value={Map.get(@address, "city", "")} id={"#{assigns.id}-city"} />
          </div>
        </Field>

        <Field class="field" name="state">
          <Label class="label">State</Label>
          <div class="control">
            <TextInput class="input" value={Map.get(@address, "state", "")} id={"#{assigns.id}-state"} />
          </div>
        </Field>

        <Field class="field" name="zip">
          <Label class="label">Zip</Label>
          <div class="control">
            <TextInput class="input" value={Map.get(@address, "zip", "")} id={"#{assigns.id}-zip"} />
          </div>
        </Field>

        <Field class="field" name="phone">
          <Label class="label">Home Phone</Label>
          <div class="control">
            <TextInput class="input" value={Map.get(@address, "phone", "")} id={"#{assigns.id}-phone"} />
          </div>
        </Field>

        </Form>
        </div>

        <div>
          <footer class="card-footer" :if={@can_delete}>
            <div class="card-footer-item card-remove-button">
              <button type="button" class="button is-small is-danger is-light" :on-click="delete_address">Remove Household</button>
              </div>
          </footer>
        </div>
      </div>
    """
  end

  @impl true
  def handle_event("add_adult", _value, socket) do
    send(self(), {:add_adult, socket.assigns.index})
    {:noreply, socket}
  end

  @impl true
  def handle_event("update_address", %{"address" => params}, socket) do
    send(self(), {:update_address, socket.assigns.index, params})
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete_address", _params, socket) do
    send(self(), {:delete_address, socket.assigns.index})
    {:noreply, socket}
  end
end
