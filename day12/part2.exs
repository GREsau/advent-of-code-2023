defmodule Part2 do
  def run(lines) do
    result = lines
      |> Enum.map(&run_single/1)
      |> Enum.sum()
      |> Integer.to_string()
    IO.puts("Part 2: " <> result)
  end

  def run_single({chars, groups}) do
    chars5 = chars ++ ~c"?" ++ chars ++ ~c"?" ++ chars ++ ~c"?" ++ chars ++ ~c"?" ++ chars
    groups5 = groups ++ groups ++ groups ++ groups ++ groups

    :ets.new(:aoc_memo, [:set, :protected, :named_table])
    result = run_single(chars5, [0 | groups5 ]) + run_single(chars5, groups5)
    :ets.delete(:aoc_memo)
    result
  end

  def run_single(chars, [0]) do
    if Enum.all?(chars, fn c -> c !== ?# end) do
      1
    else
      0
    end
  end

  def run_single([c | c_rest], [0 | g_rest]) do
    if c !== ?# do
      case :ets.lookup(:aoc_memo, [c_rest, g_rest]) do
        [] ->
          result = run_single(c_rest, [0 | g_rest]) + run_single(c_rest, g_rest)
          :ets.insert(:aoc_memo, {[c_rest, g_rest], result})
          result
        [{_, result} | _] -> result
      end
    else
      0
    end
  end

  def run_single([c | c_rest], [g | g_rest]) do
    if c !== ?. and g > 0 do
      run_single(c_rest, [g-1 | g_rest])
    else
      0
    end
  end

  def run_single([], _groups) do
    0
  end
end
