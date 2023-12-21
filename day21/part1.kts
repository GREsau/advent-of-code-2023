import java.io.File
import java.awt.Point

fun readInput(): Pair<Set<Point>, Point> {
  val rocks = mutableSetOf<Point>()
  var start = Point(-1, -1)

  val reader = File("input.txt").bufferedReader()

  for ((y, line) in reader.lineSequence().withIndex()) {
    for ((x, char) in line.withIndex()) {
      when (char) {
        'S' -> start = Point(x, y)
        '#' -> rocks.add(Point(x, y))
        else -> {}
      }
    }
  }

  reader.close()

  return Pair(rocks, start)
}

fun Point.neighbours(): List<Point> {
  return listOf(Point(x+1, y), Point(x-1, y), Point(x, y+1), Point(x, y-1))
}

val (rocks, start) = readInput()

var currentSpaces = setOf(start)

for (t in 1..64) {
  val nextSpaces = mutableSetOf<Point>()
  for (space in currentSpaces.asSequence().flatMap { p -> p.neighbours() }) {
    if (!(space in rocks)) {
      nextSpaces.add(space)
    }
  }
  currentSpaces = nextSpaces
}

println("Part 1: ${currentSpaces.size}")
