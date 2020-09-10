defmodule RumblWeb.VideoChannelTest do
  use RumblWeb.ChannelCase

  import RumblWeb.TestHelpers

  setup do
    user = insert_user(name: "Gary")
    video = insert_video(user, title: "Testing")
    token = Phoenix.Token.sign(@endpoint, "user socket", user.id)
    {:ok, socket} = connect(RumblWeb.UserSocket, %{"token" => token})

    # see issue https://github.com/phoenixframework/phoenix/issues/3619
    on_exit(fn ->
      for pid <- Task.Supervisor.children(RumblWeb.Presence.TaskSupervisor) do
        ref = Process.monitor(pid)
        assert_receive {:DOWN, ^ref, _, _, _}, 1000
      end
      :timer.sleep(200)
    end)

    {:ok, socket: socket, user: user, video: video}
  end

  test "inserting new annotations", %{socket: socket, video: video} do
    {:ok, _, socket} = subscribe_and_join(socket, "videos:#{video.id}", %{})
    ref = push(socket, "new_annotation", %{body: "the body", at: 0})

    assert_reply ref, :ok, %{}
    assert_broadcast "new_annotation", %{}
  end

  test "new annotation triggers InfoSys", %{socket: socket, video: video} do
    insert_user(username: "wolfram", password: "supersecret")
    {:ok, _, socket} = subscribe_and_join(socket, "videos:#{video.id}", %{})
    ref = push(socket, "new_annotation", %{body: "1 + 1", at: 123})

    assert_reply ref, :ok, %{}
    assert_broadcast "new_annotation", %{body: "1 + 1", at: 123}
    assert_broadcast "new_annotation", %{body: "2", at: 123}
  end
end
