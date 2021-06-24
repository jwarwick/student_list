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
    tmp_file = "directory.rtf"
    tmp_dir = System.tmp_dir!
    tmp_path = Path.join(tmp_dir, tmp_file)
    :ok = Formatter.write(tmp_path)

    conn
    |> put_resp_content_type("application/rtf")
    |> put_resp_header("content-disposition",
                       "attachment; filename=\"#{tmp_file}\"")
    |> send_file(200, tmp_path)
  end
end
