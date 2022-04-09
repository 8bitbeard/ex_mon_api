defmodule ExMonWeb.FallbackController do
  use ExMonWeb, :controller

  alias ExMon.Error
  alias ExMonWeb.ErrorView

  def call(conn, {:error, %Error{status: status, result: result}}) do
    conn
    |> put_status(status)
    |> put_view(ErrorView)
    |> render("error.json", result: result)
  end
end
