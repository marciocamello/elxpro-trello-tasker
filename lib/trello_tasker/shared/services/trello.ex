defmodule TrelloTasker.Shared.Services.Trello do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://api.trello.com/1/cards"
  plug Tesla.Middleware.Headers, [{"User-Agent", "request"}]
  plug Tesla.Middleware.JSON

  @token Application.get_env(:trello_tasker, :trello)[:token]
  @key Application.get_env(:trello_tasker, :trello)[:key]

  def get_comments(card_id) do
    {:ok, response} =
      "#{card_id}/actions?commentCard&key=" <> @key <> "&token=" <> @token
      |> get()

      body = response.body

      body
      |> Enum.map(&%{text: &1["data"]["text"], user: &1["memberCreator"]["username"]})
      |> IO.inspect
  end

  def get_card(card_id) do
    {:ok, response} =
      "#{card_id}?list=true&key=" <> @key <> "&token=" <> @token
      |> get()

    status = response.status

    if status != 200 do
      {:error, "Error after find card"}
    else
      body = response.body

      {:ok, deliver_date, _} = body["due"] |> DateTime.from_iso8601()

      thumb_url =
        body["cover"]["scaled"]
        |> hd()

      %{
        name: body["name"],
        description: body["desc"],
        image: body["cover"]["sharedSourceUrl"],
        thumb: thumb_url["url"],
        card_id: body["shortLink"],
        completed: body["dueComplete"],
        deliver_date: deliver_date |> DateTime.to_date(),
      }
    end
  end
end
