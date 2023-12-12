defmodule Part1 do
  def run(lines) do
    result = Enum.sum(Enum.map(lines, &run_single/1))
    IO.puts("Part 1: " <> Integer.to_string(result))
  end

  def run_single({chars, groups}) do
    run_single(chars, groups) + run_single(chars, [0 | groups ])
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
      run_single(c_rest, [0 | g_rest]) + run_single(c_rest, g_rest)
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
