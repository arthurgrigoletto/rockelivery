defmodule Rockelivery.ViaCep.ClientTest do
  use ExUnit.Case, async: true

  alias Plug.Conn
  alias Rockelivery.Error
  alias Rockelivery.ViaCep.Client

  describe "get_cep_info/1" do
    setup do
      bypass = Bypass.open()

      {:ok, bypass: bypass}
    end

    defp endpoint_url(port), do: "http://localhost:#{port}"

    test "should return cep info if cep is valid", %{bypass: bypass} do
      cep = "01001000"

      url = endpoint_url(bypass.port)

      body = ~s({
        "cep": "01001-000",
        "logradouro": "Praça da Sé",
        "complemento": "lado ímpar",
        "bairro": "Sé",
        "localidade": "São Paulo",
        "uf": "SP",
        "ibge": "3550308",
        "gia": "1004",
        "ddd": "11",
        "siafi": "7107"
      })

      Bypass.expect(bypass, "GET", "#{cep}/json", fn conn ->
        conn
        |> Conn.put_resp_header("content-type", "application/json")
        |> Conn.resp(200, body)
      end)

      response = Client.get_cep_info(url, cep)

      expected_response =
        {:ok,
         %{
           "bairro" => "Sé",
           "cep" => "01001-000",
           "complemento" => "lado ímpar",
           "ddd" => "11",
           "gia" => "1004",
           "ibge" => "3550308",
           "localidade" => "São Paulo",
           "logradouro" => "Praça da Sé",
           "siafi" => "7107",
           "uf" => "SP"
         }}

      assert response == expected_response
    end

    test "should return an error if cep is invalid", %{bypass: bypass} do
      cep = "123"

      url = endpoint_url(bypass.port)

      Bypass.expect(bypass, "GET", "#{cep}/json", fn conn ->
        Conn.resp(conn, 400, "")
      end)

      response = Client.get_cep_info(url, cep)

      expected_response = {:error, %Error{result: "Invalid CEP", status: :bad_request}}

      assert response == expected_response
    end

    test "should return an error if cep was not found", %{bypass: bypass} do
      cep = "00000000"

      url = endpoint_url(bypass.port)

      body = ~s({"erro": true})

      Bypass.expect(bypass, "GET", "#{cep}/json", fn conn ->
        conn
        |> Conn.put_resp_header("content-type", "application/json")
        |> Conn.resp(200, body)
      end)

      response = Client.get_cep_info(url, cep)

      expected_response = {:error, %Error{result: "CEP not found", status: :not_found}}

      assert response == expected_response
    end

    test "should return an error if there is an generic error", %{bypass: bypass} do
      cep = "00000000"

      url = endpoint_url(bypass.port)

      Bypass.down(bypass)

      response = Client.get_cep_info(url, cep)

      expected_response = {:error, %Error{result: :econnrefused, status: :bad_request}}

      assert response == expected_response
    end
  end
end
