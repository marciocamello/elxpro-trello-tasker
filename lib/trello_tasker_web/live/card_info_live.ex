defmodule TrelloTaskerWeb.CardInfoLive do
  use TrelloTaskerWeb, :live_view

  alias Phoenix.View
  alias TrelloTaskerWeb.CardView
  alias TrelloTasker.Shared.Services.Trello

  @impl true
  def mount(%{"id" => id}, _session, socket) do

    card = Trello.get_card(id)
    comments = Trello.get_comments(id)
    {:ok, socket |> assign(comments: comments, card: card)}
  end

  @impl true
  def render(assigns) do
    View.render(CardView, "info.html", assigns)
  end
end
