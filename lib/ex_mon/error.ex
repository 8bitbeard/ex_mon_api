defmodule ExMon.Error do
  @keys [:status, :result]

  @enforce_keys @keys

  defstruct @keys

  def build(status, result) do
    %__MODULE__{
      status: status,
      result: result
    }
  end

  def build_pokemon_not_found_error, do: build(:not_found, "Pokemon not found!")
  def build_invalid_id_format, do: build(:bad_request, "Invalid UUID format!")
  def build_trainer_not_found, do: build(:not_found, "Trainer not found!")
  def build_unauthorized, do: build(:unauthorized, "Unauthorized")
end
