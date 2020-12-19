defmodule TrelloTaskerWeb.CardInfoLive do
  use TrelloTaskerWeb, :live_view

  alias Phoenix.View
  alias TrelloTaskerWeb.CardView
  alias  TrelloTasker.Shared.Services.GetCardInfo

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {comments, card} = GetCardInfo.execute(id)
    {:ok, socket |> assign(comments: comments, card: card)}
  end

  @impl true
  def render(assigns) do
    View.render(CardView, "info.html", assigns)
  end
end
