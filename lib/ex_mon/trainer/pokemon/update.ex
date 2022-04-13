defmodule ExMon.Trainer.Pokemon.Update do
  alias Ecto.UUID
  alias ExMon.{Error, Repo, Trainer.Pokemon}

  def call(%{"id" => uuid} = params) do
    case UUID.cast(uuid) do
      :error -> {:error, Error.build_invalid_id_format()}
      {:ok, _uuid} -> update(params)
    end
  end

  defp update(%{"id" => uuid} = params) do
    case Repo.get(Pokemon, uuid) do
      nil -> {:error, Error.build_pokemon_not_found_error()}
      pokemon -> update_pokemon(pokemon, params)
    end
  end

  defp update_pokemon(trainer, params) do
    trainer
    |> Pokemon.update_changeset(params)
    |> Repo.update()
  end
end
