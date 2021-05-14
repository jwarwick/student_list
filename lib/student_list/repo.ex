defmodule StudentList.Repo do
  use Ecto.Repo,
    otp_app: :student_list,
    adapter: Ecto.Adapters.Postgres
end
