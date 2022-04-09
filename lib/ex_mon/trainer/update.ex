defmodule ExMon.Trainer.Update do
  alias Ecto.UUID
  alias ExMon.{Error, Repo, Trainer}

  def call(%{"id" => uuid} = params) do
    case UUID.cast(uuid) do
      :error -> {:error, Error.build_invalid_id_format()}
      {:ok, _uuid} -> update(params)
    end
  end

  defp update(%{"id" => uuid} = params) do
    case fetch_trainer(uuid) do
      nil -> {:error, Error.build_trainer_not_found()}
      trainer -> update_trainer(trainer, params)
    end
  end

  defp fetch_trainer(uuid), do: Repo.get(Trainer, uuid)

  defp update_trainer(trainer, params) do
    trainer
    |> Trainer.changeset(params)
    |> Repo.update()
  end
end
