defmodule Main do
  def parse_line(line) do
    [w1, w2] = String.split(line)
    chars = String.to_charlist(w1)
    groups = Enum.map(String.split(w2, ","), &String.to_integer/1)
    {chars, groups}
  end
end

lines = Enum.map(File.stream!("input.txt"), &Main.parse_line/1)

Code.compile_file("part1.exs")
Part1.run(lines)

Code.compile_file("part2.exs")
Part2.run(lines)
