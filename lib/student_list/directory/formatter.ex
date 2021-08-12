defmodule StudentList.Directory.Formatter do
  @moduledoc """
  Output the directory in an RTF format
  """
  require EEx

  alias StudentList.Directory

  EEx.function_from_file(:def, :directory,
                         Path.expand("templates/directory.rtf.eex", :code.priv_dir(:student_list)),
                         [:assigns])
  EEx.function_from_file(:def, :class,
                         Path.expand("templates/class.rtf.eex", :code.priv_dir(:student_list)),
                         [:assigns])
  EEx.function_from_file(:def, :student,
                         Path.expand("templates/student.rtf.eex", :code.priv_dir(:student_list)),
                         [:assigns])

  @doc """
  Generate the RTF string
  """
  def create do
    directory(classes: Directory.get_listing())
  end

  @doc """
  Generate RTF file
  """
  def write do
    tmp_file = "directory.rtf"
    tmp_dir = System.tmp_dir!
    tmp_path = Path.join(tmp_dir, tmp_file)
    result = create()
    :ok = File.write(Path.expand(tmp_path), result)
    {:ok, tmp_path}
  end
end
