import java.io.File
import java.awt.Point
import java.math.BigInteger

val target = 26501365

fun readInput(): Triple<Set<Point>, Point, Int> {
  val rocks = mutableSetOf<Point>()
  var start = Point(-1, -1)

  val reader = File("input.txt").bufferedReader()
  var height = 0
  var width = 0

  for ((y, line) in reader.lineSequence().withIndex()) {
    height = y
    for ((x, char) in line.withIndex()) {
      width = x
      when (char) {
        'S' -> start = Point(x, y)
        '#' -> rocks.add(Point(x, y))
        else -> {}
      }
    }
  }

  height++;
  width++;

  // check() doesn't seem to work when run from a script :/
  // check(width == height)
  // check(width % 2 == 1)
  // check((target - width/2) % (width * 2) == 0)
  // check(start.x == height / 2)
  // check(start.y == height / 2)

  reader.close()

  return Triple(rocks, start, width)
}

fun Point.neighbours(): List<Point> {
  return listOf(Point(x+1, y), Point(x-1, y), Point(x, y+1), Point(x, y-1))
}

val (rocks, start, size) = readInput()

fun Point.isValid(): Boolean {
  return x >= 0 && y >= 0 && x < size && y < size && !(this in rocks)
}


fun run(start: Point, steps: Int): Long {
  var currentSpaces = setOf(start)

  for (t in 1..steps) {
    val nextSpaces = mutableSetOf<Point>()
    for (space in currentSpaces.asSequence().flatMap { p -> p.neighbours() }) {
      if (space.isValid()) {
        nextSpaces.add(space)
      }
    }
    currentSpaces = nextSpaces
  }

  return currentSpaces.size.toLong()
}

val cycles = ((target - size/2) / size).toLong()

val mostlyEmptyBlocksPerEdge = cycles
val mostlyFullBlocksPerEdge = cycles - 1

val max = size-1
val half = size/2

val result = cycles*cycles * run(start, max) +
  (cycles-1)*(cycles-1) * run(start, size) +
  mostlyEmptyBlocksPerEdge * run(Point(0,0), half-1) +
  mostlyEmptyBlocksPerEdge * run(Point(0,max), half-1) +
  mostlyEmptyBlocksPerEdge * run(Point(max,0), half-1) +
  mostlyEmptyBlocksPerEdge * run(Point(max,max), half-1) +
  mostlyFullBlocksPerEdge * run(Point(0,0), max+half) +
  mostlyFullBlocksPerEdge * run(Point(0,max), max+half) +
  mostlyFullBlocksPerEdge * run(Point(max,0), max+half) +
  mostlyFullBlocksPerEdge * run(Point(max,max), max+half) +
  run(Point(0, half), max) +
  run(Point(half, 0), max) +
  run(Point(max, half), max) +
  run(Point(half, max), max)

println("Part 2: ${result}")
