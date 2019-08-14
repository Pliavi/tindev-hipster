defmodule GithubUserAPI do
  use HTTPoison.Base

  @expected_fields ~w(login avatar_url name bio)

  # All GitHub api requests need User-Agent
  def get!(url, headers \\ [], options \\ []),
    do: request!(:get, url, "", [headers | ["User-Agent": "GithubUserApi"]], options)

  def process_request_url(username) do
    "https://api.github.com/users/" <> username
  end

  def process_response_body(body) do
    body
    |> Poison.decode!()
    |> Map.take(@expected_fields)
    |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
  end
end
