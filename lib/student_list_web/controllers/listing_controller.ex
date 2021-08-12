defmodule StudentListWeb.ListingController do
  use StudentListWeb, :controller

  alias StudentList.Directory
  alias StudentList.Directory.Formatter
  
  plug(:put_root_layout, {StudentListWeb.LayoutView, "torch.html"})
  plug(:put_layout, false)
  
  def index(conn, _params) do
    render(conn, "index.html", classes: Directory.get_listing())
  end

  def download(conn, _params) do
    {:ok, tmp_path} = Formatter.write()

    conn
    |> put_resp_content_type("application/rtf")
    |> put_resp_header("content-disposition",
                       "attachment; filename=\"directory.rtf\"")
    |> send_file(200, tmp_path)
  end
end
