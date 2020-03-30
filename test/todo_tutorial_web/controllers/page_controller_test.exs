defmodule TodoTutorialWeb.PageControllerTest do
  use TodoTutorialWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert response(conn, 200)
  end
end
