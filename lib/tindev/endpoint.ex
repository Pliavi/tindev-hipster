defmodule Tindev.Endpoint do
  use Plug.Router

  @content_type "application/json"
  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison
  )

  plug(:dispatch)

  post "/login" do
    {:ok, database} = Tindev.Database.get()
    username = String.downcase(conn.body_params["username"])
    result = Mongo.find_one(database, "developers", %{username: username})

    if result == nil do
      github_user = GithubUserAPI.get!(username).body

      last_inserted_id =
        database
        |> Mongo.insert_one!("developers", %{
          name:
            if(String.length(github_user[:name]) == 0,
              do: github_user[:username],
              else: github_user[:name]
            ),
          username: String.downcase(github_user[:login]),
          bio: github_user[:bio],
          avatar: github_user[:avatar_url]
        })
        |> Map.delete("inserted_id")

      inserted_user =
        database
        |> Mongo.find_one("developers", %{_id: last_inserted_id.inserted_id})
        |> Map.delete("_id")

      conn
      |> put_resp_content_type(@content_type)
      |> send_resp(200, Poison.encode!(inserted_user))
    else
      conn |> send_resp(200, result |> Map.delete("_id") |> Poison.encode!())
    end
  end

  match _ do
    send_resp(conn, 404, "Rota inexistente")
  end
end
