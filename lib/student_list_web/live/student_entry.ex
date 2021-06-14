defmodule StudentListWeb.Live.StudentEntry do
  use Surface.LiveComponent

  alias StudentListWeb.Live.{ClassEntry, BusEntry}
  alias Surface.Components.Form.{Field, Label, TextInput}

  data first_name, :string, default: ""
  data last_name, :string, default: ""

  def render(assigns) do
    ~H"""
    <div>
      <Field name="first_name">
        <Label>First Name</Label>
        <div class="control">
          <TextInput value={{@first_name}}/>
        </div>
      </Field>

      <Field name="last_name">
        <Label>Last Name</Label>
        <div class="control">
          <TextInput value={{@last_name}}/>
        </div>
      </Field>

      <ClassEntry id="classroom" />
      <BusEntry id="bus" />
    
    </div>
    """
  end

end
