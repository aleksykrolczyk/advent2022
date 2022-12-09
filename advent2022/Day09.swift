//
// Created by Aleksy Krolczyk on 09/12/2022.
//

import Foundation

fileprivate let MAX_DISTANCE = 2

fileprivate enum Direction {
    case up, down, left, right

    init?(_ c: String?) {
        switch c {
        case "U": self = .up
        case "D": self = .down
        case "L": self = .left
        case "R": self = .right
        default:  return nil
        }
    }
}

fileprivate struct Point: Hashable {
    var x: Int
    var y: Int

    mutating func move(x: Int = 0, y: Int = 0) {
        self.x += x
        self.y += y
    }

    mutating func move(by point: Point) {
        x += point.x
        y += point.y
    }

    func dist(to other: Point) -> Int {
        let dx = x - other.x
        let dy = y - other.y
        return dx * dx + dy * dy
    }

    var constrained: Point {
        Point(x: x.signum(), y: y.signum())
    }
}

fileprivate class Rope {
    private var knots: [Point]
    private var knotsCount: Int
    var uniqueTailPositions: Set<Point> = Set([Point(x: 0, y: 0)])

    init(segmentsApartFromHead: Int) {
        knotsCount = segmentsApartFromHead + 1
        knots = Array(repeating: Point(x: 0, y: 0), count: knotsCount)
    }

    func moveHead(direction: Direction) {
        switch direction {
            case .up:    knots[0].move(y: 1)
            case .down:  knots[0].move(y: -1)
            case .left:  knots[0].move(x: -1)
            case .right: knots[0].move(x: 1)
        }

        for i in 1 ..< knotsCount {
            updateKnot(i)
        }

        uniqueTailPositions.insert(knots.last!)
    }

    private func updateKnot(_ i: Int) {
        if knots[i].dist(to: knots[i - 1]) <= MAX_DISTANCE { return }
        let distance = (knots[i - 1] - knots[i])
        knots[i].move(by: distance.constrained)
    }
}

class Day09: AdventDay {
    fileprivate let instructions: [(direction: Direction, times: Int)]

    required init(_ data: String) {
        instructions = data.components(separatedBy: "\n").map { line in
            let x = line.components(separatedBy: " ")
            return (direction: Direction(x.first)!, times: Int(x.last!)!)
        }
    }

    func part1() {
        let grid = Rope(segmentsApartFromHead: 1)
        for inst in instructions {
            for _ in 0 ..< inst.times {
                grid.moveHead(direction: inst.direction)
            }
        }
        print(grid.uniqueTailPositions.count)
    }

    func part2() {
        let grid = Rope(segmentsApartFromHead: 9)
        for inst in instructions {
            for _ in 0 ..< inst.times {
                grid.moveHead(direction: inst.direction)
            }
        }
        print(grid.uniqueTailPositions.count)
    }
}


extension Point { // operators
    static func + (self: Point, other: Point) -> Point {
        Point(x: self.x + other.x, y: self.y + other.y)
    }

    static func - (self: Point, other: Point) -> Point {
        Point(x: self.x - other.x, y: self.y - other.y)
    }

    static func == (self: Point, other: Point) -> Bool {
        self.x == other.x && self.y == other.y
    }

    static func != (self: Point, other: Point) -> Bool {
        !(self == other)
    }
}

extension Rope {
    func draw() {
        let s = knotsCount * 2
        var grid = Array(repeating: Array(repeating: ".", count: s), count: s)
        grid[s - 1][0] = "s"
        for i in stride(from: knotsCount - 1, through: 1, by: -1) {
            grid[s - 1 - knots[i].y][knots[i].x] = String(i)
        }
        grid[s - 1 - knots[0].y][knots[0].x] = "H"

        for row in grid {
            print(row.joined())
        }
    }
}