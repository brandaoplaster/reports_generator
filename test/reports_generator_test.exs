defmodule ReportsGeneratorTest do
  use ExUnit.Case

  describe "build/1" do
    test "build the report" do
      file_name = "report_test.csv"

      response = ReportsGenerator.build(file_name)

      expected_response = %{
        "foods" => %{
          "churrasco" => 60,
          "esfirra" => 85,
          "pastel" => 0,
          "pizza" => 75,
          "sushi" => 0,
          "açaí" => 45,
          "hambúrguer" => 80,
          "prato_feito" => 0
        },
        "users" => %{
          "1" => 48,
          "10" => 36,
          "11" => 0,
          "12" => 0,
          "13" => 0,
          "14" => 0,
          "15" => 0,
          "16" => 0,
          "17" => 0,
          "18" => 0,
          "19" => 0,
          "2" => 45,
          "20" => 0,
          "21" => 0,
          "22" => 0,
          "23" => 0,
          "24" => 0,
          "25" => 0,
          "26" => 0,
          "27" => 0,
          "28" => 0,
          "29" => 0,
          "3" => 31,
          "30" => 0,
          "4" => 42,
          "5" => 49,
          "6" => 18,
          "7" => 27,
          "8" => 25,
          "9" => 24
        }
      }

      assert response == expected_response
    end
  end

  describe "feat_higher_cost/2" do
    test "when the option is 'users', returns the user who spent most" do
      file_name = "report_test.csv"

      response =
        file_name
        |> ReportsGenerator.build()
        |> ReportsGenerator.feat_higher_cost("users")

      expected_response = {:ok, {"5", 49}}

      assert response == expected_response
    end

    test "when the option is 'foods', returns the most consumed food" do
      file_name = "report_test.csv"

      response =
        file_name
        |> ReportsGenerator.build()
        |> ReportsGenerator.feat_higher_cost("foods")

      expected_response = {:ok, {"esfirra", 85}}

      assert response == expected_response
    end

    test "when invalid option is given, returns an error" do
      file_name = "report_test.csv"

      response =
        file_name
        |> ReportsGenerator.build()
        |> ReportsGenerator.feat_higher_cost("invalid")

      expected_response = {:error, "Invalid option!"}

      assert response == expected_response
    end
  end
end
