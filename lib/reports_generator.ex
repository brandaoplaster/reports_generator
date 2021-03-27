defmodule ReportsGenerator do
  alias ReportsGenerator.Parser

  @available_foods [
    "açaí",
    "churrasco",
    "esfirra",
    "hambúrguer",
    "pastel",
    "pizza",
    "prato_feito",
    "sushi"
  ]

  @options ["foods", "users"]

  def build(file_name) do
    file_name
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), fn line, report ->
      sum_values(line, report)
    end)
  end

  def build_from_many(files_names) do
    files_names
    |> Task.async_stream(&build/1)
    |> Enum.reduce(report_acc(), fn {:ok, result}, report ->
      sum_reports(report, result)
    end)
  end

  def sum_reports(%{"foods" => foods_a, "users" => users_a}, %{
        "foods" => foods_b,
        "users" => users_b
      }) do
    foods = merge_maps(foods_a, foods_b)
    users = merge_maps(users_a, users_b)

    build_report(foods, users)
  end

  defp merge_maps(map_a, map_b) do
    Map.merge(map_a, map_b, fn _key, value_a, value_b -> value_a + value_b end)
  end

  def feat_higher_cost(report, option) when option in @options do
    result =
      report[option]
      |> Enum.max_by(fn {_key, value} -> value end)

    {:ok, result}
  end

  def feat_higher_cost(_report, _option), do: {:error, "Invalid option!"}

  defp sum_values([id, food, price], %{"foods" => foods, "users" => users}) do
    users = Map.put(users, id, users[id] + price)
    foods = Map.put(foods, food, foods[food] + price)

    build_report(foods, users)
  end

  defp report_acc() do
    foods = Enum.into(@available_foods, %{}, &{&1, 0})
    users = Enum.into(1..30, %{}, &{Integer.to_string(&1), 0})

    build_report(foods, users)
  end

  defp build_report(foods, users), do: %{"users" => users, "foods" => foods}
end
