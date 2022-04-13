defmodule ExMon.Trainer.Pokemon.Get do
  alias Ecto.UUID
  alias ExMon.{Error, Repo, Trainer.Pokemon}

  def call(id) do
    case UUID.cast(id) do
      :error -> {:error, Error.build_invalid_id_format()}
      {:ok, uuid} -> get(uuid)
    end
  end

  defp get(uuid) do
    case Repo.get(Pokemon, uuid) do
      nil -> {:error, Error.build_pokemon_not_found_error()}
      pokemon -> {:ok, Repo.preload(pokemon, :trainer)}
    end
  end
end
