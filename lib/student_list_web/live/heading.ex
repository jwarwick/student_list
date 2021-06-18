defmodule StudentListWeb.Live.Heading do
  use Surface.Component

  prop support_email, :string, default: nil

  def render(assigns) do
    ~F"""
    <div class="jumbotron">
      <div class="container">
        <h1>Add your information!</h1>
        Enter your information to be included in the student directory. All fields are optional.
        <div class="support-email" :if={@support_email}>
          Questions or comments? Email <a href={"mailto:#{@support_email}?Subject=Support"}>{@support_email}</a>
        </div>
      </div>
    </div>
    """
  end
end
