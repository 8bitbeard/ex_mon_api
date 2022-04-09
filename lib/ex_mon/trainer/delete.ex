defmodule ExMon.Trainer.Delete do
  alias Ecto.UUID
  alias ExMon.{Error, Repo, Trainer}

  def call(id) do
    case UUID.cast(id) do
      :error -> {:error, Error.build_invalid_id_format()}
      {:ok, uuid} -> delete(uuid)
    end
  end

  defp delete(uuid) do
    case fetch_trainer(uuid) do
      nil -> {:error, Error.build_trainer_not_found()}
      trainer -> Repo.delete(trainer)
    end
  end

  defp fetch_trainer(uuid), do: Repo.get(Trainer, uuid)
end
