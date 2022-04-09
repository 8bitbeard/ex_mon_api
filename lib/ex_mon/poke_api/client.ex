defmodule ExMon.PokeApi.Client do
  use Tesla

  alias ExMon.Error

  plug Tesla.Middleware.BaseUrl, "https://pokeapi.co/api/v2"
  plug Tesla.Middleware.JSON

  def get_pokemon(name) do
    "/pokemon/#{name}"
    |> get()
    |> handle_get()
  end

  defp handle_get({:ok, %Tesla.Env{status: 200, body: body}}), do: {:ok, body}

  defp handle_get({:ok, %Tesla.Env{status: 404}}),
    do: {:error, Error.build_pokemon_not_found_error()}

  defp handle_get({:error, _reason} = error), do: error
end
