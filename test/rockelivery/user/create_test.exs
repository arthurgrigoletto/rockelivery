defmodule Rockelivery.Users.CreateTest do
  use Rockelivery.DataCase, async: true

  import Mox
  import Rockelivery.Factory

  alias Rockelivery.{Error, User}
  alias Rockelivery.Users.Create
  alias Rockelivery.ViaCep.ClientMock

  describe "call/1" do
    test "should return an user when all params are valid" do
      params = build(:user_params)

      expect(ClientMock, :get_cep_info, fn _cep ->
        {:ok, build(:cep_info)}
      end)

      response = Create.call(params)

      assert {:ok, %User{id: _id, age: 27, email: "arthur@gmail.com"}} = response
    end

    test "should return an error when there are invalid params" do
      params = build(:user_params, %{"age" => 15, "password" => "123"})

      response = Create.call(params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        password: ["should be at least 6 character(s)"]
      }

      assert {:error, %Error{status: :bad_request, result: changeset}} = response

      assert errors_on(changeset) == expected_response
    end
  end
end
