defmodule Rockelivery.UserTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Ecto.Changeset
  alias Rockelivery.User

  describe "changeset/1" do
    test "should return a valid changeset when all params are valid" do
      params = build(:user_params)

      response = User.changeset(params)

      assert %Changeset{changes: %{name: "arthur"}, valid?: true} = response
    end

    test "should return an invalid changeset when ther are some errors" do
      params = build(:user_params, %{age: 15, password: "123"})

      response = User.changeset(params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        password: ["should be at least 6 character(s)"]
      }

      assert errors_on(response) == expected_response
    end
  end

  describe "changeset/2" do
    test "should return a valid changeset with update call when params are valid" do
      params = build(:user_params)

      update_params = %{name: "Arthur grigoletto"}

      response =
        params
        |> User.changeset()
        |> User.changeset(update_params)

      assert %Changeset{changes: %{name: "Arthur grigoletto"}, valid?: true} = response
    end

    test "should return an invalid changeset when ther are some errors" do
      params = build(:user_params)

      update_params = %{age: 15}

      response =
        params
        |> User.changeset()
        |> User.changeset(update_params)

      expected_response = %{
        age: ["must be greater than or equal to 18"]
      }

      assert errors_on(response) == expected_response
    end
  end
end
