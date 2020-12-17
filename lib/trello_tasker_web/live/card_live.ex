defmodule TrelloTaskerWeb.CardLive do
  use TrelloTaskerWeb, :live_view

  alias Phoenix.View
  alias TrelloTasker.Cards.Card
  alias TrelloTaskerWeb.CardView
  alias TrelloTasker.Shared.Services.Trello

  @impl true
  def mount(_params, _session, socket) do

    changeset = Card.changeset(%Card{})
    card = Trello.get_card("jyliuSO2")

    socket = socket
    |> assign(cards: [card, card], changeset: changeset)
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    View.render(CardView, "index.html", assigns)
  end
end
