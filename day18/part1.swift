import Foundation

enum Direction: Character, CaseIterable   {
    case up = "U"
    case right = "R"
    case down = "D"
    case left = "L"
}

struct Step {
    let direction: Direction
    let distance: Int

    init(direction: Direction, distance: Int) {
        self.direction = direction
        self.distance = distance
    }

    init(parse string: any StringProtocol) {
        let words = string.split(separator: " ")
        self.direction = Direction(rawValue: string[string.startIndex])!
        self.distance = Int(words[1])!
    }
}

struct Point: Hashable {
    let x, y: Int

    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }

    func go(_ direction: Direction) -> Point {
        switch direction {
        case .up:
            Point(x, y-1)
        case .right:
            Point(x+1, y)
        case .down:
            Point(x, y+1)
        case .left:
            Point(x-1, y)
        }
    }

    static func byX(a: Point, b: Point) -> Bool {
        a.x < b.x
    }

    static func byY(a: Point, b: Point) -> Bool {
        a.y < b.y
    }
}

func parseInput() -> [Step] {
    try! String(contentsOfFile: "input.txt")
        .split(separator: "\n")
        .map { Step(parse: $0) }
}

func totalSize(_ holes: Set<Point>) -> Int {
    var (xmin, xmax, ymin, ymax) = (0,0,0,0)
    for p in holes {
        xmin = min(xmin, p.x)
        xmax = max(xmax, p.x)
        ymin = min(ymin, p.y)
        ymax = max(ymax, p.y)
    }

    xmin -= 1
    xmax += 1
    ymin -= 1
    ymax += 1

    let xrange = xmin...xmax
    let yrange = ymin...ymax
    var unprocessed: Set = [Point(xmin,ymin), Point(xmin,ymax), Point(xmax,ymin), Point(xmax,ymax)]
    var solids = unprocessed

    while !unprocessed.isEmpty {
        let copy = unprocessed
        unprocessed = []
        for p in copy {
            for d in Direction.allCases {
                // TODO bounds check
                let neighbour = p.go(d)
                if xrange.contains(neighbour.x)
                && yrange.contains(neighbour.y)
                && !holes.contains(neighbour)
                && !solids.contains(neighbour) {
                    unprocessed.insert(neighbour)
                    solids.insert(neighbour)
                }
            }
        }
    }

    return xrange.count * yrange.count - solids.count
}

var pos = Point(0,0)
var holes: Set = [pos]

for step in parseInput() {
    for _ in 0..<step.distance {
        pos = pos.go(step.direction)
        holes.insert(pos)
    }
}

print("Part 1:", totalSize(holes))