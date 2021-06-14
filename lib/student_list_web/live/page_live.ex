defmodule StudentListWeb.PageLive do
  use Surface.LiveView

  alias StudentListWeb.Live.{Heading, StudentEntry}

  data submitted, :boolean, default: false

  # @impl true
  # def mount(_params, _session, socket) do
  #   {:ok, socket}
  # end

  @impl true
  def render(assigns) do
    ~H"""
    <div :if={{@submitted}}>
     <h1>Thanks for entering your info!</h1>
    </div>
    <div :if={{!@submitted}}>
      <Heading />
      <StudentEntry id="student" />
      <button class="button is-info" :on-click="submit_form">Submit</button>
    </div>
    """
  end

  def handle_event("submit_form", _value, socket) do
    IO.inspect(socket.assigns)
    socket = assign(socket, submitted: true)
    {:noreply, socket}
  end
end
