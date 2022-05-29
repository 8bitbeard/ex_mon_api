defmodule ExMonWeb.Controllers.TrainersControllerTest do
  use ExMonWeb.ConnCase

  alias ExMon.Trainer

  describe "show/2" do
    test "when there is a trainer with the given id, returns the trainer", %{conn: conn} do
      params = %{name: "Wilton", password: "123456"}

      {:ok, %Trainer{id: id}} = ExMon.create_trainer(params)

      response =
        conn
        |> get(Routes.trainers_path(conn, :show, id))
        |> json_response(:ok)

      assert %{"id" => ^id, "inserted_at" => _inserted_at, "name" => "Wilton"} = response
    end

    test "when an invalid UUID is informed, returns an error", %{conn: conn} do
      response =
        conn
        |> get(Routes.trainers_path(conn, :show, "1234"))
        |> json_response(:bad_request)

      assert response == %{"message" => "Invalid UUID format!"}
    end

    test "when an inexistent UUID is informed, returns an error", %{conn: conn} do
      response =
        conn
        |> get(Routes.trainers_path(conn, :show, "79df2bee-49f7-4a24-8d4f-364aaa71966c"))
        |> json_response(:not_found)

      assert response == %{"message" => "Trainer not found!"}
    end
  end
end
