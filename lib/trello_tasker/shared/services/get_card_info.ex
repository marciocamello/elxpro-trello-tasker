defmodule TrelloTasker.Shared.Services.GetCardInfo do
  alias TrelloTasker.Shared.Services.Trello
  alias TrelloTasker.Shared.CacheProvider.CardCacheClient

  @table "cards-list"

  def execute(id) do
    CardCacheClient.recover(id)
    |> case do
      {:ok, {comments, card}} ->
        {comments, card}
      {:not_found, []} ->
        {:ok, cards} = CardCacheClient.recover(@table)

        card =
          cards
          |> Enum.find(& &1.card_id == id)

        comments = Trello.get_comments(id)
        CardCacheClient.save(id, {comments, card})

        {comments, card}
    end
  end
end
