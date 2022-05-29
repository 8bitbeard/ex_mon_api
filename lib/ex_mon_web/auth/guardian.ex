defmodule ExMonWeb.Auth.Guardian do
  use Guardian, otp_app: :ex_mon

  alias Ecto.UUID
  alias ExMon.{Error, Repo, Trainer}

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    claims
    |> Map.get("sub")
    |> ExMon.fetch_trainer()
  end

  def authenticate(%{"id" => trainer_id, "password" => password}) do
    case UUID.cast(trainer_id) do
      :error -> {:error, Error.build_invalid_id_format()}
      {:ok, uuid} -> get_trainer(uuid, password)
    end
  end

  defp get_trainer(uuid, password) do
    case Repo.get(Trainer, uuid) do
      nil -> {:error, Error.build_trainer_not_found()}
      trainer -> validate_password(trainer, password)
    end
  end

  defp validate_password(%Trainer{password_hash: hash} = trainer, password) do
    case Argon2.verify_pass(password, hash) do
      true -> create_token(trainer)
      false -> {:error, Error.build_unauthorized()}
    end
  end

  defp create_token(trainer) do
    {:ok, token, _claims} = encode_and_sign(trainer)
    {:ok, token}
  end
end
