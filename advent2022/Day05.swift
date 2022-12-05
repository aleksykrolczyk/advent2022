//
// Created by Aleksy Krolczyk on 05/12/2022.
//

import Foundation

extension Array where Element == [Character] {
    var topElements: String {
        var res = ""
        for elem in self {
            res = "\(res)\(elem.last!)"
        }
        return res
    }
}

class Day05: AdventDay {

    var stacks1: [[Character]]
    var stacks2: [[Character]]

    let orders: [(count: Int, from: Int, to: Int)]

    required init(_ data: String) {
        var readStacks = true
        var _stacks: [[Character]] = []
        var _orders: [(Int, Int, Int)] = []

        var firstLine = true
        var lineLength = -1
        data.enumerateLines { line, _ in
            if line.isEmpty { readStacks = false }

            if readStacks && !line.isEmpty {
                if firstLine {
                    lineLength = line.count
                    for _ in stride(from: 1, through: lineLength, by: 4) {
                        _stacks.append([])
                    }
                    firstLine = false
                }

                for col in stride(from: 1, through: lineLength, by: 4) {
                    let char = line[line.index(line.startIndex, offsetBy: col)]
                    if char.isLetter {
                        _stacks[(Int(col - 1) / 4 )].insert(char, at: 0)
                    }
                }

            } else if !line.isEmpty {
                let numbers = line
                    .split(separator: " ")
                    .filter { sequence in  sequence.allSatisfy { $0.isNumber }}
                    .map { sequence in Int(sequence)! }
                _orders.append((
                    count: numbers[0], from: numbers[1] - 1, to: numbers[2] - 1
                ))

            }
        }

        stacks1 = _stacks
        stacks2 = _stacks
        orders = _orders
    }

    func part1() {
        for order in orders {
            for _ in 0 ..< order.count {
                stacks1[order.to].append(stacks1[order.from].popLast()!)
            }
        }
        print(stacks1.topElements)

    }

    func part2() {
        for order in orders {
            var buffer: [Character] = []
            for _ in 0 ..< order.count {
                buffer.append(stacks2[order.from].popLast()!)
            }
            while !buffer.isEmpty {
                stacks2[order.to].append(buffer.popLast()!)
            }
        }
        print(stacks2.topElements)
    }

}
