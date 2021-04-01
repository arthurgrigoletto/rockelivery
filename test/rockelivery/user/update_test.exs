defmodule Rockelivery.Users.UpdateTest do
  use Rockelivery.DataCase, async: true
  import Rockelivery.Factory

  alias Rockelivery.{Error, User}
  alias Rockelivery.Users.Update

  describe "call/1" do
    test "should be able to update an user" do
      id = "69b9e884-a0c4-40ec-9d19-efb479e99b6f"
      insert(:user)

      update_params = %{
        "id" => id,
        "name" => "Arthur Grigoletto"
      }

      response = Update.call(update_params)

      assert {:ok, %User{id: "69b9e884-a0c4-40ec-9d19-efb479e99b6f", name: "Arthur Grigoletto"}} =
               response
    end

    test "should not be able to update an inexist user" do
      response = Update.call(%{"id" => "cf3f4ac8-ee1f-4e09-8fa0-6d1ab4c0c7ce"})

      expected_response = {:error, %Error{result: "User not found", status: :not_found}}

      assert response == expected_response
    end
  end
end
