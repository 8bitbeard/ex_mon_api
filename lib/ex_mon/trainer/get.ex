defmodule ExMon.Trainer.Get do
  alias Ecto.UUID
  alias ExMon.{Error, Repo, Trainer}

  def call(id) do
    case UUID.cast(id) do
      :error -> {:error, Error.build_invalid_id_format()}
      {:ok, uuid} -> get(uuid)
    end
  end

  defp get(uuid) do
    case Repo.get(Trainer, uuid) do
      nil -> {:error, Error.build_trainer_not_found()}
      trainer -> {:ok, trainer}
    end
  end
end
