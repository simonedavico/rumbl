defmodule RumblWeb.WatchView do
  use RumblWeb, :view

  alias Rumbl.Multimedia.Video

  def player_id(%Video{} = video) do
    ~r{^.*(?:youtu\.be/|\w+/|v=)(?<id>[^#&?]*)}
      |> Regex.named_captures(video.url)
      |> get_in(["id"])
  end
end
