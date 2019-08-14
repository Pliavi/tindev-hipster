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
      githubUser = GithubUserAPI.get!(username).body

      lastInsertedID =
        Mongo.insert_one!(database, "developers", %{
          name:
            if(String.length(githubUser[:name]) == 0,
              do: githubUser[:username],
              else: githubUser[:name]
            ),
          username: String.downcase(githubUser[:login]),
          bio: githubUser[:bio],
          avatar: githubUser[:avatar_url]
        })
        |> Map.delete("inserted_id")

      insertedUser =
        Mongo.find_one(database, "developers", %{_id: lastInsertedID.inserted_id})
        |> Map.delete("_id")

      conn
      |> put_resp_content_type(@content_type)
      |> send_resp(200, Poison.encode!(insertedUser))
    else
      conn |> send_resp(200, result |> Map.delete("_id") |> Poison.encode!())
    end
  end

  match _ do
    send_resp(conn, 404, "Rota inexistente")
  end
end
