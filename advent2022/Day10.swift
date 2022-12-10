//
// Created by Aleksy Krolczyk on 10/12/2022.
//

import Foundation

fileprivate let STOPS = [20, 60, 100, 140, 180, 220]
fileprivate let CRT_WIDTH = 40

fileprivate enum Instruction {
    case noop, addx(value: Int)
    var cycles: Int {
        switch self {
            case .noop: return 1
            case .addx: return 2
        }
    }
}

class Day10: AdventDay {
    fileprivate let instructions: [Instruction]

    required init(_ data: String) {
        instructions = data.components(separatedBy: "\n").map { line in
            let x = line.components(separatedBy: " ")
            switch x[0] {
                case "noop": return .noop
                case "addx": return .addx(value: Int(x[1])!)
                default: fatalError()
            }
        }
    }

    func part1() {
        var x = 1
        var cycle = 0
        var signalStrengthsSum = 0

        for instruction in instructions {
            for _ in 0 ..< instruction.cycles {
                cycle += 1
                if STOPS.contains(cycle) {
                    signalStrengthsSum += cycle * x
                }
            }

            switch instruction {
            case .noop:
                break
            case .addx(value: let value):
                x += value
            }
        }
        print(signalStrengthsSum)
    }

    func part2() {
        var x = 1
        var pos = 0

        for instruction in instructions {
            for _ in 0 ..< instruction.cycles {
                let shouldNewline = pos == CRT_WIDTH - 1
                print(
                    abs(x - pos) <= 1 ? "#" : ".",
                    terminator: shouldNewline ? "\n" : ""
                )
                pos = shouldNewline ? 0 : pos + 1
            }

            switch instruction {
            case .noop:
                break
            case .addx(value: let value):
                x += value
            }
        }
    }

}
