//
// Created by Aleksy Krolczyk on 03/12/2022.
//

import Foundation

extension ClosedRange where Bound: Comparable {
    func contains(_ other: ClosedRange<Bound>) -> Bool {
        lowerBound <= other.lowerBound && upperBound >= other.upperBound
    }
}

class Day04: AdventDay {
    let pairs: [(left: ClosedRange<Int>, right: ClosedRange<Int>)]

    required init(_ data: String) {
        pairs = data.split(separator: "\n").map { line in
            let split = line.split(separator: ",")
            let left = split[0].split(separator: "-")
            let right = split[1].split(separator: "-")
            return (
                left: Int(left[0])! ... Int(left[1])!,
                right: Int(right[0])! ... Int(right[1])!
            )
        }
    }

    func part1() {
        let count = pairs.filter { left, right in left.contains(right) || right.contains(left) }.count
        print(count)
    }

    func part2() {
        let count = pairs.filter { left, right in left.overlaps(right) }.count
        print(count)
    }
}
