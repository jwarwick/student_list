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
    # classes = Directory
    #   Class
    #   # |> Class.sorted
    #   |> Repo.all
    #   |> Repo.preload([students: from(Student, order_by: [:last_name])])
    #   |> Repo.preload([students: [:bus, :class, [parents: :address]]])

    directory(classes: Directory.get_listing())
  end

  @doc """
  Generate RTF file
  """
  def write(path) do
    result = create()
    File.write(Path.expand(path), result)
  end
end
