defmodule Rockelivery.Users.GetTest do
  use Rockelivery.DataCase, async: true
  import Rockelivery.Factory

  alias Rockelivery.{Error, User}
  alias Rockelivery.Users.Get

  describe "by_id/1" do
    test "should be able to find an user by id" do
      id = "69b9e884-a0c4-40ec-9d19-efb479e99b6f"
      insert(:user)

      response = Get.by_id(id)

      assert {:ok, %User{id: "69b9e884-a0c4-40ec-9d19-efb479e99b6f"}} = response
    end

    test "should not be able to find an inexisting user" do
      response = Get.by_id("cf3f4ac8-ee1f-4e09-8fa0-6d1ab4c0c7ce")

      expected_response = {:error, %Error{result: "User not found", status: :not_found}}

      assert response == expected_response
    end
  end
end
