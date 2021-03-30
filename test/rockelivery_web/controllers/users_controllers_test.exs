defmodule RockeliveryWeb.UsersControllerTest do
  use RockeliveryWeb.ConnCase, async: true

  import Rockelivery.Factory

  alias Rockelivery.User

  describe "create/2" do
    test "should create an user when all params are valid", %{conn: conn} do
      params = %{
        "age" => 27,
        "address" => "Rua das bananeiras, 15",
        "cep" => "12345678",
        "cpf" => "12345678900",
        "email" => "arthur@gmail.com",
        "password" => "123456",
        "name" => "arthur"
      }

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:created)

      assert %{
               "message" => "User Created",
               "user" => %{
                 "address" => "Rua das bananeiras, 15",
                 "age" => 27,
                 "cpf" => "12345678900",
                 "email" => "arthur@gmail.com",
                 "id" => _id,
                 "name" => "arthur"
               }
             } = response
    end

    test "should return an error when there are invalid params", %{conn: conn} do
      params = %{
        "password" => "123456",
        "name" => "arthur"
      }

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:bad_request)

      expected_response = %{
        "message" => %{
          "address" => ["can't be blank"],
          "age" => ["can't be blank"],
          "cep" => ["can't be blank"],
          "cpf" => ["can't be blank"],
          "email" => ["can't be blank"]
        }
      }

      assert response == expected_response
    end
  end

  describe "delete/2" do
    test "should delete the user when user exists", %{conn: conn} do
      id = "69b9e884-a0c4-40ec-9d19-efb479e99b6f"
      insert(:user)

      response =
        conn
        |> delete(Routes.users_path(conn, :delete, id))
        |> response(:no_content)

      assert response == ""
    end
  end

  describe "show/2" do
    test "should show the user when user exists", %{conn: conn} do
      id = "69b9e884-a0c4-40ec-9d19-efb479e99b6f"
      insert(:user)

      response =
        conn
        |> get(Routes.users_path(conn, :show, id))
        |> json_response(:ok)

      assert %{
               "user" => %{
                 "address" => "Rua das bananeiras, 15",
                 "age" => 27,
                 "cpf" => "12345678900",
                 "email" => "arthur@gmail.com",
                 "id" => "69b9e884-a0c4-40ec-9d19-efb479e99b6f",
                 "name" => "arthur"
               }
             } = response
    end
  end

  describe "update/2" do
    test "should be able to update user", %{conn: conn} do
      id = "69b9e884-a0c4-40ec-9d19-efb479e99b6f"
      insert(:user)

      params = %User{
        id: id,
        age: 27,
        address: "Rua das bananeiras, 15",
        cep: "12345678",
        cpf: "12345678900",
        email: "arthur@gmail.com",
        password: "123456",
        name: "Arthur Grigoletto"
      }

      response =
        conn
        |> put(Routes.users_path(conn, :update, params))
        |> json_response(:ok)

      assert %{
               "user" => %{
                 "address" => "Rua das bananeiras, 15",
                 "age" => 27,
                 "cpf" => "12345678900",
                 "email" => "arthur@gmail.com",
                 "id" => _id,
                 "name" => "arthur"
               }
             } = response
    end
  end
end
