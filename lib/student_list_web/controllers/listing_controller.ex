defmodule StudentListWeb.ListingController do
  use StudentListWeb, :controller

  alias StudentList.Directory
  
  plug(:put_root_layout, {StudentListWeb.LayoutView, "torch.html"})
  plug(:put_layout, false)
  
  def index(conn, _params) do
    render(conn, "index.html", classes: Directory.get_listing())
  end
end
