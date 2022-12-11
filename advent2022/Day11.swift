//
// Created by Aleksy Krolczyk on 11/12/2022.
//

import Foundation

fileprivate enum Operation {
    case add(value: Int)
    case multiply(value: Int)
    case square

    init(string s: String) {
        let x = s.trimmingCharacters(in: .whitespaces).components(separatedBy: " ")
        let op = x[1]
        let value = x[2]

        switch op {
        case "+":
            self = .add(value: Int(value)!)
        case "*":
            self = value == "old" ? .square : .multiply(value: Int(value)!)
        default:
            fatalError()
        }
    }

    func operate(on operand: Int) -> Int {
        switch self {
            case .add(let value): return operand + value
            case .multiply(let value): return operand * value
            case .square: return operand * operand
        }
    }
}

fileprivate class Monkey {
    let id: Int
    var items: [Int]
    let operation: Operation
    let divisibilityTest: Int
    let trueMonkey: Int
    let falseMonkey: Int

    var inspections: Int = 0

    init(id: Int, items: [Int], operation: Operation, divisibilityTest: Int, trueMonkey: Int, falseMonkey: Int) {
        self.id = id
        self.items = items
        self.operation = operation
        self.divisibilityTest = divisibilityTest
        self.trueMonkey = trueMonkey
        self.falseMonkey = falseMonkey
    }

    func inspectItems(mod: Int?) -> [Int] {
        var passTo: [Int] = []
        for i in items.indices {
            if mod == nil {
                items[i] = operation.operate(on: items[i]) / 3
            }
            else {
                items[i] = operation.operate(on: items[i]) % mod!
            }
            passTo.append(items[i] % divisibilityTest == 0 ? trueMonkey : falseMonkey)
            inspections += 1
        }
        return passTo
    }
}

class Day11: AdventDay {

    fileprivate var monkeys1: [Monkey] = []
    fileprivate var monkeys2: [Monkey] = []

    required init(_ data: String) {
        let lines = data.components(separatedBy: .newlines)
        let monkeyCount: Int = (lines.count + 1) / 7
        for i in 0 ..< monkeyCount {
            let startingItems = lines[i * 7 + 1]
                .components(separatedBy: ":")[1]
                .components(separatedBy: ",")
                .map { c in Int(c.trimmingCharacters(in: .whitespaces))!}

            monkeys1.append(Monkey(
                id: i,
                items: startingItems,
                operation: Operation(string: lines[i * 7 + 2].components(separatedBy: "=")[1]),
                divisibilityTest: Int(lines[i * 7 + 3].components(separatedBy: .whitespaces).last!)!,
                trueMonkey: Int(lines[i * 7 + 4].components(separatedBy: .whitespaces).last!)!,
                falseMonkey: Int(lines[i * 7 + 5].components(separatedBy: .whitespaces).last!)!
            ))

            monkeys2.append(Monkey(
                id: i,
                items: startingItems,
                operation: Operation(string: lines[i * 7 + 2].components(separatedBy: "=")[1]),
                divisibilityTest: Int(lines[i * 7 + 3].components(separatedBy: .whitespaces).last!)!,
                trueMonkey: Int(lines[i * 7 + 4].components(separatedBy: .whitespaces).last!)!,
                falseMonkey: Int(lines[i * 7 + 5].components(separatedBy: .whitespaces).last!)!
            ))

        }
    }

    func part1() {
        for _ in 0 ..< 20 {
            for monkey in monkeys1 {
                let passTo = monkey.inspectItems(mod: nil)
                for i in passTo {
                    monkeys1[i].items.append(monkey.items.removeFirst())
                }
            }
        }
        let x = monkeys1.map { $0.inspections }.sorted(by: > )
        print(x[0] * x[1])
    }

    func part2() {
        let mod = monkeys2.map { $0.divisibilityTest }.reduce(1, *)
        for _ in 0 ..< 10000 {
            for monkey in monkeys2 {
                let passTo = monkey.inspectItems(mod: mod)
                for i in passTo {
                    monkeys2[i].items.append(monkey.items.removeFirst())
                }
            }
        }
        let x = monkeys2.map { $0.inspections }.sorted(by: > )
        print(x[0] * x[1])
    }
}


extension Monkey: CustomStringConvertible {
    var description: String {
        "\(id), \(items), \(operation), \(divisibilityTest), \(trueMonkey), \(falseMonkey)"
    }
}