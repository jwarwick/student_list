defmodule StudentListWeb.HeadingTest do
  use StudentListWeb.ConnCase
  use Surface.LiveViewTest

  alias StudentListWeb.Live.Heading

  @endpoint Endpoint

  test "render a header without email address" do
    html = render_surface do
      ~F"""
      <Heading />
      """
    end

    assert html =~ "Add your information!"
    assert html =~ "Enter your information to be included in the student directory"
    refute html =~ "Questions or comments? Email"
  end

  test "render a header with email address" do
    html = render_surface do
      ~F"""
      <Heading support_email="bob@example.com"/>
      """
    end

    assert html =~ "Add your information!"
    assert html =~ "Enter your information to be included in the student directory"
    assert html =~ "Questions or comments? Email"
    assert html =~ "mailto:bob@example.com"
  end
end
