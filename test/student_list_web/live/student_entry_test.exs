defmodule StudentListWeb.StudentEntryTest do
  use StudentListWeb.ConnCase
  use Surface.LiveViewTest

  alias StudentListWeb.Live.StudentEntry

  @endpoint Endpoint

  test "render a student entry component" do
    html = render_surface do
      ~F"""
      <StudentEntry
        id={"test-1"}
        student={%{}}
        index={0}
        sorted_buses={[]}
        sorted_classrooms={[]}
        can_delete={false} />
      """
    end

    assert html =~ "Student"
    assert html =~ "First Name"
    assert html =~ "Last Name"
    assert html =~ "Classroom"
    assert html =~ "Bus"
    refute html =~ "phx-click=\"delete_student\""
  end

  test "render a deletable student entry component" do
    html = render_surface do
      ~F"""
      <StudentEntry
        id={"test-1"}
        student={%{}}
        index={0}
        sorted_buses={[]}
        sorted_classrooms={[]}
        can_delete={true} />
      """
    end

    assert html =~ "Student"
    assert html =~ "First Name"
    assert html =~ "Last Name"
    assert html =~ "Classroom"
    assert html =~ "Bus"
    assert html =~ "phx-click=\"delete_student\""
  end
end
