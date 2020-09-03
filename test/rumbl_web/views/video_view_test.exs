defmodule RumblWeb.VideoViewTest do
  use RumblWeb.ConnCase, async: true
  import Phoenix.View

  test "renders index.html", %{conn: conn} do
    videos = [
      %Rumbl.Multimedia.Video{id: 1, title: "a", category: %Rumbl.Multimedia.Category{id: 1, name: "test"}},
      %Rumbl.Multimedia.Video{id: 2, title: "b", category: %Rumbl.Multimedia.Category{id: 1, name: "test"}}
    ]

    content = render_to_string(
      RumblWeb.VideoView,
      "index.html",
      conn: conn,
      videos: videos
    )

    assert String.contains?(content, "Listing Videos")

    for video <- videos do
      assert String.contains?(content, video.title)
    end
  end

  test "renders new.html", %{conn: conn} do
    changeset = Rumbl.Multimedia.change_video(%Rumbl.Multimedia.Video{})
    categories = [%Rumbl.Multimedia.Category{id: 1, name: "test"}]

    content = render_to_string(
      RumblWeb.VideoView,
      "new.html",
      conn: conn,
      changeset: changeset,
      categories: categories
    )

    assert String.contains?(content, "New Video")
  end
end
