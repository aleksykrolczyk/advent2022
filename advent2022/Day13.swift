//
// Created by Aleksy Krolczyk on 13/12/2022.
//

fileprivate let DIVIDER1 = "[[2]]"
fileprivate let DIVIDER2 = "[[6]]"

import Foundation

fileprivate enum Packet {
    case number(Int)
    indirect case list ([Packet])

    init(_ str: String) {
        var depth = -1
        var tree: [Int: Packet] = [:]

        var i = 0
        while i < str.count - 1 {
            switch str[i] {
            case "[":
                tree[depth + 1] = .list([])
                depth += 1
            case "]":
                let temp = tree[depth]!
                tree[depth - 1]?.append(temp)
                depth -= 1
            case _ where str[i].isNumber:
                if !str[i + 1].isNumber {
                    tree[depth]?.append(.number(str[i].wholeNumberValue!))
                }
                else {
                    tree[depth]?.append(.number(10)) // worst code of my life
                    i += 1
                }

            default:
                break
            }
            i += 1
        }
        self = tree[0]!
    }

    mutating func append(_ value: Packet) {
        switch self {
        case .number:
            break
        case .list(var x):
            x.append(value)
            self = .list(x)
        }
    }

    static func compare(_ lhs: Packet, _ rhs: Packet) -> Int {
        switch (lhs, rhs) {
        case (.number(let left), .number(let right)):
//            print("NN Comparing: \(lhs) and \(rhs)")
            return (right - left).signum()

        case (.list, .number):
//            print("LN Comparing: \(lhs) and \(rhs)")
            return compare(lhs, .list([rhs]))

        case (.number, .list):
//            print("NL Comparing: \(lhs) and \(rhs)")
            return compare(.list([lhs]), rhs)

        case (.list(let left), .list(let right)):
//            print("LL Comparing: \(lhs) and \(rhs)")
            for i in 0..<min(left.count, right.count) {
                let res = compare(left[i], right[i])
                if res != 0 {
                    return res
                }
            }
            return (right.count - left.count).signum()
        }
    }
}

fileprivate struct Pair {
    let left: Packet
    let right: Packet
}

class Day13: AdventDay {
    fileprivate let pairs: [Pair]
    fileprivate let allPackets: [Packet]

    required init(_ data: String) {
        var _pairs: [Pair] = []
        var _all: [Packet] = []
        let x = data.components(separatedBy: "\n")

        for i in stride(from: 0, through: x.count, by: 3) {
            let left = Packet(x[i])
            let right = Packet(x[i + 1])
            _pairs.append(Pair(left: left, right: right))
            _all.append(contentsOf: [left, right])
        }

        _all.append(contentsOf: [Packet(DIVIDER1), Packet(DIVIDER2)])

        pairs = _pairs
        allPackets = _all
    }

    func part1() {
        let s = pairs.enumerated()
                .compactMap { (i, pair) in Packet.compare(pair.left, pair.right) > 0 ? i + 1 : nil}
                .reduce(0, +)
        print(s)
    }

    func part2() {
        let sorted = allPackets.sorted(by: { Packet.compare($0, $1) > 0 })
        let p1 = (sorted.firstIndex { $0.description == DIVIDER1 })! + 1
        let p2 = (sorted.firstIndex { $0.description == DIVIDER2 })! + 1
        print(p1 * p2)
    }
}


extension Packet: CustomStringConvertible {
    var description: String {
        switch self {
        case .number(let x): return "\(x)"
        case .list(let x):   return "\(x)"
        }
    }
}
