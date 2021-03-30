defmodule Rockelivery.Factory do
  use ExMachina.Ecto, repo: Rockelivery.Repo

  alias Rockelivery.User

  def user_params_factory do
    %{
      age: 27,
      address: "Rua das bananeiras, 15",
      cep: "12345678",
      cpf: "12345678900",
      email: "arthur@gmail.com",
      password: "123456",
      name: "arthur"
    }
  end

  def user_factory do
    %User{
      age: 27,
      address: "Rua das bananeiras, 15",
      cep: "12345678",
      cpf: "12345678900",
      email: "arthur@gmail.com",
      password: "123456",
      name: "arthur",
      id: "69b9e884-a0c4-40ec-9d19-efb479e99b6f"
    }
  end
end
