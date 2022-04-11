defmodule ExMon.Trainer.Pokemon.Delete do
  alias Ecto.UUID
  alias ExMon.{Error, Repo}
  alias ExMon.Trainer.Pokemon

  def call(id) do
    case UUID.cast(id) do
      :error -> {:error, Error.build_invalid_id_format()}
      {:ok, uuid} -> delete(uuid)
    end
  end

  defp delete(uuid) do
    case fetch_pokemon(uuid) do
      nil -> {:error, Error.build_pokemon_not_found_error()}
      pokemon -> Repo.delete(pokemon)
    end
  end

  defp fetch_pokemon(uuid), do: Repo.get(Pokemon, uuid)
end
