defmodule ReportsGenerator do
  alias ReportsGenerator.Parser

  @available_foods [
    "açai",
    "churrasco",
    "esfirra",
    "humbúrguer",
    "pastel",
    "pizza",
    "sushi"
  ]

  @options ["foods", "users"]

  def build(filename) do
    filename
    |> Parser.parse_line()
    |> Enum.reduce(report_acc(), fn line, report ->
      sum_values(line, report)
    end)
  end

  def feat_higher_cost(report, option) when option in @options do
    result =
      report[option]
      |> Enum.max_by(fn {_key, value} -> value end)

    {:ok, result}
  end

  def feat_higher_cost(_report, _option), do: {:error, "Invalid option!"}

  defp sum_values([id, food, price], %{"foods" => foods, "users" => users} = report) do
    users = Map.put(users, id, users[id] + price)
    foods = Map.put(foods, food, foods[food] + price)

    report
    |> Map.put("users", users)
    |> Map.put("foods", foods)
  end

  defp report_acc() do
    foods = Enum.into(@available_foods, %{}, &{&1, 0})
    users = Enum.into(1..30, %{}, &{Integer.to_string(&1), 0})

    %{"users" => users, "foods" => foods}
  end
end
