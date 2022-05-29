defmodule ExMon.Trainer.CreateTest do
  use ExMon.DataCase

  alias ExMon.{Error, Repo, Trainer}
  alias Trainer.Create

  describe "call/1" do
    test "when all params are valid, creates a trainer" do
      params = %{name: "Wilton", password: "123456"}

      count_before = Repo.aggregate(Trainer, :count)

      response = Create.call(params)

      count_after = Repo.aggregate(Trainer, :count)

      assert {:ok, %Trainer{name: "Wilton"}} = response
      assert count_after > count_before
    end

    test "when there are invalid params, returns the error" do
      params = %{name: "Wilton"}

      response = Create.call(params)

      assert {:error, %Error{result: changeset}} = response
      assert errors_on(changeset) == %{password: ["can't be blank"]}
    end
  end
end
