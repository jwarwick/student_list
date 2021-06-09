defmodule StudentListWeb.Live.ClassEntry do
  use Surface.LiveComponent

  alias Surface.Components.Form.{Field, Label, Select}

  data user, :string, default: "a trivia question"

  def render(assigns) do
    ~H"""
    <Field name="classroom">
      <Label>Classroom</Label>
      <div class="select">
        <Select options={{ "Admin": "admin", "User": "user" }} />
      </div>
    </Field>
    """
  end

end
