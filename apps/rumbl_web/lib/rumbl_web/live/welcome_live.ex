defmodule RumblWeb.WelcomeLive do
  use RumblWeb, :live_view

  def render(assigns) do
    ~L"""
      <div>
        <h2><%= @salutation %></h2>
      </div>
    """
  end

  def mount(_params, _session, socket) do
    salutation = "Welcome to LiveView"
    {:ok, assign(socket, salutation: salutation)}
  end
end
