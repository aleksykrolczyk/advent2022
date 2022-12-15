//
// Created by Aleksy Krolczyk on 14/12/2022.
//

import Foundation

fileprivate let SAND_COL = 500

fileprivate struct Pair: Equatable, CustomStringConvertible {
    let x: Int
    let y: Int

    var description: String { "(\(x), \(y))" }
    var tupled: (Int, Int) { (x, y) }

    func takeMin(_ x: Int, y: Int) -> Pair {
        Pair(x: min(self.x, x), y: min(self.y, y))
    }

    func takeMax(_ x: Int, y: Int) -> Pair {
        Pair(x: max(self.x, x), y: max(self.y, y))
    }

    static func - (self: Pair, other: Pair) -> Pair {
        Pair(x: self.x - other.x, y: self.y - other.y)
    }

    static func + (self: Pair, other: Pair) -> Pair {
        Pair(x: self.x + other.x, y: self.y + other.y)
    }

    static func + (self: Pair, other: (Int, Int)) -> Pair {
        Pair(x: self.x + other.0, y: self.y + other.1)
    }

}

fileprivate enum Tile: CustomStringConvertible {
    case empty, sand, rock
    var description: String {
        switch self {
        case .empty: return "."
        case .rock:  return "#"
        case .sand:  return "o"
        }
    }
    var isFree: Bool {
        switch self {
        case .empty: return true
        default:     return false
        }
    }

}

fileprivate struct Cave {
    private var grid: [[Tile]]
    private let sandCol: Int

    private mutating func drawLine(of tileType: Tile, from: Pair, size: Pair) {
        print("drawLine: \(from), \(size)")
        switch size.tupled {
        case (0, let y):
            for i in min(0, y) ... max(0, y) {
                grid[from.y + i][from.x + 0] = tileType
            }
        case (let x, 0):
            for i in min(0, x) ... max(0, x) {
                grid[from.y + 0][from.x + i] = tileType
            }
        default:
            fatalError()
        }
    }

    init(segmentGroups: [[Pair]], minX: Int, maxX: Int, maxY: Int) {
        let offset = maxX - minX
        grid = Array(repeating: Array(repeating: .empty, count: offset + 1), count: maxY + 1)
        sandCol = SAND_COL - minX

        for group in segmentGroups {
            for i in 1 ..< group.count {
                let start = group[i - 1] - Pair(x: minX, y: 0)
                drawLine(of: .rock, from: start, size: group[i] - group[i - 1])
            }
        }
    }

    mutating func generateSand() -> Bool {
        var pos = Pair(x: sandCol, y: 0)
        while true {
            if pos.y == grid.count - 1 || pos.x == grid[0].count - 1 || pos.x == 0 {
                return true
            }
            if grid[pos.y + 1][pos.x].isFree {
                pos = pos + (0, 1)
            } else if grid[pos.y + 1][pos.x - 1].isFree {
                pos = pos + (-1, 1)
            } else if grid[pos.y + 1][pos.x + 1].isFree {
                pos = pos + (1, 1)
            } else {
                grid[pos.y][pos.x] = .sand
                return false
            }
        }
    }

    mutating func generateSand2() -> Bool {
        if grid[0][sandCol] == .sand { return true }

        var pos = Pair(x: sandCol, y: 0)
        while true {
            if grid[pos.y + 1][pos.x].isFree {
                pos = pos + (0, 1)
            } else if grid[pos.y + 1][pos.x - 1].isFree {
                pos = pos + (-1, 1)
            } else if grid[pos.y + 1][pos.x + 1].isFree {
                pos = pos + (1, 1)
            } else {
                grid[pos.y][pos.x] = .sand
                return false
            }
        }
    }

}


class Day14: AdventDay {
    fileprivate var cave: Cave
    fileprivate var cave2: Cave

    required init(_ data: String) {
        var (minX, maxX, maxY) = (Int.max, Int.min, Int.min)
        var segmentGroups: [[Pair]] = []

        data.components(separatedBy: "\n").forEach { line in
            var currGroup: [Pair] = []
            line.components(separatedBy: " -> ").forEach { pair in
                let p = pair.components(separatedBy: ",").compactMap { Int($0) }
                minX = min(minX, p[0])
                maxX = max(maxX, p[0])
                maxY = max(maxY, p[1])
                currGroup.append(Pair(x: p[0], y: p[1]))
            }
            segmentGroups.append(currGroup)
        }

        cave = Cave(segmentGroups: segmentGroups, minX: minX, maxX: maxX, maxY: maxY)

        minX = 300
        maxX = 700
        maxY = maxY + 2
        segmentGroups.append([Pair(x: minX, y: maxY), Pair(x: maxX, y: maxY)])
        cave2 = Cave(segmentGroups: segmentGroups, minX: minX, maxX: maxX, maxY: maxY)
    }

    func part1() {
        var i = 0
        cave.pprint()

        var end = false
        while !end {
            end = cave.generateSand()
            i += 1
        }
        cave.pprint()
        print(i)
    }

    func part2() {
        var i = 0
        cave.pprint()
        var end = false
        while !end {
            end = cave2.generateSand2()
            i += 1
        }
        cave2.pprint()
        print(i)
    }
}
//155 78/

extension Cave {
    func pprint() {
        for row in grid {
            for elem in row {
                print(elem, terminator: "")
            }
            print()
        }
    }
}