//
// Created by Aleksy Krolczyk on 08/12/2022.
//

import Foundation

class Day08: AdventDay {

    let forestSize: Int
    let forest: [[Int]]
    var isVisible: [[Bool?]]

    required init(_ data: String) {
        let split = data.split(separator: "\n")
        forestSize = split[0].count
        forest = split.map { line in line.map { $0.wholeNumberValue! }}
        isVisible = Array(repeating: Array(repeating: nil, count: forestSize), count: forestSize)

        isVisible[0] = Array(repeating: true, count: forestSize)
        isVisible[isVisible.count - 1] = Array(repeating: true, count: forestSize)
        for i in isVisible.indices {
            isVisible[i][0] = true
            isVisible[i][isVisible[1].count - 1] = true

        }
//        forest.matrixPrint()
    }
    func part1() {
        for i in 1 ..< forestSize - 1 {
            for j in 1 ..< forestSize - 1 {
                let v = forest.values(i, j)
                let x = forest[i][j]
                isVisible[i][j] = x > v.up.max()! || x > v.down.max()! || x > v.left.max()! || x > v.right.max()!
            }
        }
        print(isVisible.trueCount)
    }

    func part2() {
        var maxScenicScore = Int.min
        for i in 1..<forestSize - 1 {
            for j in 1..<forestSize - 1 {
                let s = forest.smallerThan(i, j)
                let score = s.up * s.down * s.left * s.right
                maxScenicScore = max(maxScenicScore, score)
            }
        }
        print(maxScenicScore)
    }
}

fileprivate extension Array where Element == Array<Int> {
    func matrixPrint() {
        for elem in self {
            print(elem)
        }
    }

    func values(_ i: Int, _ j: Int) -> (up: [Int], down: [Int], left: [Int], right: [Int]) {
        (
            up: stride(from: i - 1, through: 0, by: -1).map { self[$0][j] },
            down: stride(from: i + 1, through: count - 1, by: 1).map { self[$0][j] },
            left: stride(from: j - 1, through: 0, by: -1).map { self[i][$0] },
            right: stride(from: j + 1, through: count - 1, by: 1).map { self[i][$0] }
        )
    }

    func smallerThan(_ i: Int, _ j: Int) -> (up: Int, down: Int, left: Int, right: Int) {
        var sUp = 0
        for x in stride(from: i - 1, through: 0, by: -1) {
            sUp += 1
            if self[i][j] <= self[x][j] { break }
        }

        var sDown = 0
        for x in stride(from: i + 1, through: count - 1, by: 1) {
            sDown += 1
            if self[i][j] <= self[x][j] { break }
        }

        var sLeft = 0
        for y in stride(from: j - 1, through: 0, by: -1) {
            sLeft += 1
            if self[i][j] <= self[i][y] { break }
        }

        var sRight = 0
        for y in stride(from: j + 1, through: count - 1, by: 1) {
            sRight += 1
            if self[i][j] <= self[i][y] { break }
        }

        return (up: sUp, down: sDown, left: sLeft, right: sRight)
    }
}

fileprivate extension Array where Element == Array<Bool?> {
    func matrixPrint() {
        for row in self {
            for elem in row{
                print(elem != nil ? elem != true ? 1 : 0 : "x", terminator: " ")
            }
            print()
        }
    }

    var trueCount: Int {
        var s = 0
        for row in self {
            for elem in row {
                if elem == true { s += 1 }
            }
        }
        return s
    }
}
