defmodule StudentListWeb.PageLive do
  use Surface.LiveView

  alias StudentListWeb.Live.{Heading, StudentEntry}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Heading />
    <StudentEntry id="student" />
    """
  end
end
