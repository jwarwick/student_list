defmodule StudentListWeb.Live.Heading do
  @moduledoc """
  Title bar component
  """
  use Surface.Component

  prop support_email, :string, default: nil

  def render(assigns) do
    ~F"""
    <section class="hero is-primary">
      <div class="hero-body">
        <p class="title">
          Add your information!
        </p>
        <p class="subtitle">
          Enter your information to be included in the student directory. All fields are optional.
        </p>
        <p :if={@support_email} class="subtitle">
          Questions or comments? Email <a href={"mailto:#{@support_email}?Subject=Support"}>{@support_email}</a>
        </p>
      </div>
    </section>
    """
  end
end
