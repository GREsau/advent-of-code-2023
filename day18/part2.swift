import Foundation

enum Direction: Character, CaseIterable   {
    case up = "3"
    case right = "0"
    case down = "1"
    case left = "2"
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
        let hex = words[2].dropFirst(2).dropLast(1)

        let lastChar = Character(String(hex.last!))
        self.direction = Direction(rawValue: lastChar)!

        let hexDistance = hex.dropLast(1)
        self.distance = Int(hexDistance, radix: 16)!
    }
}

struct Point: Hashable {
    let x, y: Int

    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }

    func go(_ step: Step) -> Point {
        switch step.direction {
        case .up:
            Point(x, y-step.distance)
        case .right:
            Point(x+step.distance, y)
        case .down:
            Point(x, y+step.distance)
        case .left:
            Point(x-step.distance, y)
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

var pos = Point(0,0)
var vertices: [Point] = []
var result = 1

for step in parseInput() {
    pos = pos.go(step)
    vertices.append(pos)
    if step.direction == .up || step.direction == .right {
        result += step.distance
    }
}

assert(vertices.last == Point(0,0))
assert(vertices.count % 2 == 0)

for i in stride(from: 0, to: vertices.count, by: 2) {
    let p1 = vertices[i]
    let p2 = vertices[i+1]
    result += p1.x * p2.y - p1.y * p2.x
}

print("Part 2:", result)