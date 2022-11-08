defmodule WabanexWeb.SchemaTest do
  use WabanexWeb.ConnCase, async: true

  alias Wabanex.User
  alias Wabanex.Users.Create

  describe "users queries" do
    test "when a valid id is given, return the user", %{conn: conn} do
      params = %{email: "eduardo@teste.com", name: "Eduardo", password: "123456"}

      {:ok, %User{id: user_id}} = Create.call(params)

      query = """
      {
        getUser(id: "#{user_id}"){
          name
          email
        }
      }
      """

      expected_response = %{
        "data" => %{
          "getUser" => %{
            "email" => "eduardo@teste.com",
            "name" => "Eduardo"
          }
        }
      }

      response =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(:ok)

      assert response == expected_response
    end
  end

  describe "user mutation" do
    test "when all params are valid, create an user", %{conn: conn} do
      mutation = """
      mutation {
        createUser(input: {name: "Eduardo", email: "eduardo2@teste.com", password: "123456"}){
          id
          name
          email
        }
      }
      """

      response =
        conn
        |> post("/api/graphql", %{query: mutation})
        |> json_response(:ok)

      assert %{
               "data" => %{
                 "createUser" => %{
                   "email" => "eduardo2@teste.com",
                   "id" => _id,
                   "name" => "Eduardo"
                 }
               }
             } = response
    end
  end
end
