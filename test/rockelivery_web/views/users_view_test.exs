defmodule RockeliveryWeb.UsersViewTest do
  use RockeliveryWeb.ConnCase, async: true

  import Phoenix.View
  import Rockelivery.Factory

  alias Rockelivery.User
  alias RockeliveryWeb.UsersView

  test "renders create.json" do
    user = build(:user)
    token = "xpto123456"

    response = render(UsersView, "create.json", user: user, token: token)

    assert %{
             message: "User Created",
             token: "xpto123456",
             user: %User{
               address: "Rua das bananeiras, 15",
               age: 27,
               cep: "12345678",
               cpf: "12345678900",
               email: "arthur@gmail.com",
               id: "69b9e884-a0c4-40ec-9d19-efb479e99b6f",
               inserted_at: nil,
               name: "arthur",
               password: "123456",
               password_hash: nil,
               updated_at: nil
             }
           } = response
  end
end
