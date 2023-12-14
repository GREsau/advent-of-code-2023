use "collections"
use "files"
use "itertools"

type Line is Array[U8 val]

actor Part1
  let env: Env
  let lines: Array[Line ref] = []

  new create(env': Env) =>
    env = env'
    try
      let path = FilePath(FileAuth(env.root), "input.txt")
      let file = OpenFile(path) as File
      for line in file.lines() do
        lines.push((consume line).iso_array())
      end

      roll_north()?
      env.out.print("Part 1: " + total_load().string())
    end

  fun ref roll_north() ? =>
    let indexed_lines = Iter[(USize, Line ref)](lines.pairs())
    for (y, line) in indexed_lines.skip(1) do
      for (x, char) in line.pairs() do
        if char == 'O' then
          line(x)? = '.'
          roll_rock_north(x, y) ?
        end
      end
    end

  fun ref roll_rock_north(x: USize, y: USize) ? =>
    for y' in Reverse(y-1, 0) do
      if lines(y')?(x)? != '.' then
        lines(y'+1)?(x)? = 'O'
        return
      end
    end
    lines(0)?(x)? = 'O'

  fun total_load(): USize =>
    var result: USize = 0
    var row: USize = 1
    for line in lines.reverse().values() do
      for char in line.values() do
        if char == 'O' then
          result = result + row
        end
      end
      row = row + 1
    end
    result

  fun message(): String =>
    "this is the message!"
