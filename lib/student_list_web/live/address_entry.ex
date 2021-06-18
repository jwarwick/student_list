defmodule StudentListWeb.Live.AddressEntry do
  use Surface.LiveComponent

  alias Surface.Components.{Form, Link}
  alias Surface.Components.Form.{Field, Label, TextInput}

  alias StudentListWeb.Live.AdultEntry

  prop can_delete, :boolean, default: true
  prop index, :integer
  prop address, :map

  @impl true
  def render(assigns) do
    ~H"""
      <div>

       <section class="adults">
        <AdultEntry
          :for.with_index={{ {a, adult_index} <- @address.adults}}
            id="adult-{{@index}}-{{adult_index}}"
            adult={{a}}
            index={{adult_index}}
            address_index={{@index}}
            can_delete={{ length(@address.adults) > 1 }} />
    
        <button type="button" class="button is-info is-small" :on-click="add_adult">Add Another Adult</button>
       </section>

      <Form for={{:address}} change="update_address" >
        <Field name="address1">
          <Label>Address 1</Label>
          <div class="control">
            <TextInput value={{ Map.get(@address, "address1", "") }} id="{{assigns.id}}-address-1" />
          </div>
        </Field>

        <Field name="address2">
          <Label>Address 2</Label>
          <div class="control">
            <TextInput value={{ Map.get(@address, "address2", "") }} id="{{assigns.id}}-address-2" />
          </div>
        </Field>

        <Field name="city">
          <Label>City</Label>
          <div class="control">
            <TextInput value={{ Map.get(@address, "city", "") }} id="{{assigns.id}}-city" />
          </div>
        </Field>

        <Field name="state">
          <Label>State</Label>
          <div class="control">
            <TextInput value={{ Map.get(@address, "state", "") }} id="{{assigns.id}}-state" />
          </div>
        </Field>

        <Field name="zip">
          <Label>Zip</Label>
          <div class="control">
            <TextInput value={{ Map.get(@address, "zip", "") }} id="{{assigns.id}}-zip" />
          </div>
        </Field>

        <Field name="phone">
          <Label>Home Phone</Label>
          <div class="control">
            <TextInput value={{ Map.get(@address, "phone", "") }} id="{{assigns.id}}-phone" />
          </div>
        </Field>

        </Form>

        <Link :if={{@can_delete}} label="Remove Household" to="#" click="delete_address" />
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
    IO.inspect(params, label: "update address fields")
    send(self(), {:update_address, socket.assigns.index, params})
    {:noreply, socket}
  end

  @impl true
  def handle_event("update_address", %{"adult" => params, "adult_index" => adult_index_str}, socket) do
    IO.inspect(params, label: "update address adult")
    send(self(), {:update_adult, socket.assigns.index, String.to_integer(adult_index_str), params})
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete_address", _params, socket) do
    send(self(), {:delete_address, socket.assigns.index})
    {:noreply, socket}
  end
end
