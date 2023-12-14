use "collections"
use "files"
use "itertools"

actor Part2
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

      let hash_to_iteration = Map[U128, I32]()
      var iteration: I32 = 0

      while iteration < 1000000000 do
        roll_north()?
        roll_west()?
        roll_south()?
        roll_east()?

        let last_iteration = hash_to_iteration.insert_if_absent(hash_lines(), iteration)
        if last_iteration != iteration then
          // we've found a cycle!
          let cycle_size = iteration - last_iteration
          iteration = iteration + (((1000000000 - iteration) / cycle_size) * cycle_size)
          hash_to_iteration.clear()
        end

        iteration = iteration + 1
      end
      env.out.print("Part 2: " + total_load().string())
    end

  fun hash_lines(): U128 =>
    var result: U128 = 0
    var pow2: U128 = 1
    for line in lines.values() do
      for char in line.values() do
        if char == 'O' then
          result = result xor pow2
        end

        pow2 = (pow2 << 1).max(1)
      end
    end
    result

  fun ref roll_north() ? =>
    let indexed_lines = Iter[(USize, Line ref)](lines.pairs())
    for (y, line) in indexed_lines.skip(1) do
      for (x, char) in line.pairs() do
        if char == 'O' then
          line(x)? = '.'
          roll_rock_north(x, y)?
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

  fun ref roll_west() ? =>
    for (y, line) in lines.pairs() do
      let indexed_chars = Iter[(USize, U8)](line.pairs())
      for (x, char) in indexed_chars.skip(1) do
        if char == 'O' then
          line(x)? = '.'
          roll_rock_west(x, y)?
        end
      end
    end

  fun ref roll_rock_west(x: USize, y: USize) ? =>
    let line = lines(y)?
    for x' in Reverse(x-1, 0) do
      if line(x')? != '.' then
        line(x'+1)? = 'O'
        return
      end
    end
    lines(y)?(0)? = 'O'

  fun ref roll_south() ? =>
    for y in Reverse(lines.size()-2, 0) do
      let line = lines(y)?
      for (x, char) in line.pairs() do
        if char == 'O' then
          line(x)? = '.'
          roll_rock_south(x, y)?
        end
      end
    end

  fun ref roll_rock_south(x: USize, y: USize) ? =>
    let height = lines.size()
    for y' in Range(y+1, height) do
      if lines(y')?(x)? != '.' then
        lines(y'-1)?(x)? = 'O'
        return
      end
    end
    lines(height-1)?(x)? = 'O'

  fun ref roll_east() ? =>
    for (y, line) in lines.pairs() do
      for x in Reverse(line.size()-2, 0) do
        let char = line(x)?
        if char == 'O' then
          line(x)? = '.'
          roll_rock_east(x, y)?
        end
      end
    end

  fun ref roll_rock_east(x: USize, y: USize) ? =>
    let line = lines(y)?
    let width = line.size()
    for x' in Range(x+1, width) do
      if line(x')? != '.' then
        line(x'-1)? = 'O'
        return
      end
    end
    lines(y)?(width-1)? = 'O'

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
