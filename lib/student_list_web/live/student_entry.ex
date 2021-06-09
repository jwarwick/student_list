defmodule StudentListWeb.Live.StudentEntry do
  use Surface.LiveComponent

  alias StudentListWeb.Live.{ClassEntry, BusEntry}
  alias Surface.Components.Form.{Field, Label, TextInput}

  data user, :string, default: "a trivia question"

  def render(assigns) do
    ~H"""
    <div>
      <Field name="first_name">
        <Label>First Name</Label>
        <div class="control">
          <TextInput />
        </div>
      </Field>

      <Field name="last_name">
        <Label>Last Name</Label>
        <div class="control">
          <TextInput />
        </div>
      </Field>

      <ClassEntry id="classroom" />
      <BusEntry id="bus" />
    
    </div>
    """
  end

end
