defmodule StudentListWeb.Live.Heading do
  @moduledoc """
  Title bar component
  """
  use Surface.Component

  prop support_email, :string, default: nil

  def render(assigns) do
    ~F"""
    <header class="hero is-primary">
      <div class="hero-body">
        <div class="columns is-vcentered">
          <figure class="column is-narrow image">
            <img class="hero-logo" src="/images/logo.png" alt="SES Directory Logo">
          </figure>
          <div class="column">
            <h1 class="title">
              Add your information!
            </h1>
            <p class="subtitle">
              Enter your information to be included in the student directory. All fields are optional.
            </p>
            <p :if={@support_email} class="subtitle">
              Questions or comments? Email <a href={"mailto:#{@support_email}?Subject=Support"}>{@support_email}</a>
            </p>
          </div>
        </div>
      </div>
    </header>
    """
  end
end
