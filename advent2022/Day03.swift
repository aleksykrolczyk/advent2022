//
// Created by Aleksy Krolczyk on 03/12/2022.
//

import Foundation

fileprivate extension Character {
    var priority: UInt8 {
        guard let value = asciiValue else { return 0 }
        if value >= 97 && value <= 122 { // lowercase
            return value - 96
        }
        if value >= 65 && value <= 90 { //uppercase
         return value - 38
        }
        return 0
    }
}

fileprivate extension String {
    func splitInHalf() -> (left: String, right: String) {
        let middleIndex = self.index(startIndex, offsetBy: count / 2)
        let endIndex = self.index(startIndex, offsetBy: count - 1)
        return (
            left: String(self[startIndex ..< middleIndex]),
            right: String(self[middleIndex ... endIndex])
        )
    }
}


fileprivate struct Backpack {
    let left: Set<Character>
    let right: Set<Character>

    var intersection: Set<Character> {
        left.intersection(right)
    }

    var whole: Set<Character> {
        left.union(right)
    }
}

class Day03: AdventDay {
    fileprivate let backpacks: [Backpack]

    required init(_ data: String) {
        var _backpacks: [Backpack] = []
        data.enumerateLines { line, _ in
            let split = line.splitInHalf()
            _backpacks.append(Backpack(
                left: Set(split.left.map { $0 }),
                right: Set(split.right.map { $0 })
            ))

        }
        backpacks = _backpacks
    }

    func part1() {
        var sum = 0
        backpacks.forEach { backpack in
            sum += backpack.intersection.reduce(0, { $0 + Int($1.priority)} )
        }
        print(sum)
    }

    func part2() {
        var sum = 0
        for i in stride(from: 0, through: backpacks.count - 1, by: 3) {
            let b0 = backpacks[i + 0].whole
            let b1 = backpacks[i + 1].whole
            let b2 = backpacks[i + 2].whole
            let common = b0.intersection(b1).intersection(b2)
            sum += common.reduce(0, { $0 + Int($1.priority)} )
        }
        print(sum)
    }
}
