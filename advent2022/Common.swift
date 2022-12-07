//
// Created by Aleksy Krolczyk on 02/12/2022.
//

import Foundation

public protocol AdventDay {
    init(_ data: String)

    func part1() -> Void
    func part2() -> Void

    func solve() -> Void

}

extension AdventDay {
    public func solve() {
        print("Part 1:")
        part1()
        print("\nPart 2:")
        part2()
    }
}


public func preload(dayNumber: String) -> String {
    let path = "/Users/akrolczyk/Developer/advent2022/advent2022/Resources/Day\(dayNumber)"
    let content = try! String(contentsOfFile: path)
    return content
}

extension String {
    subscript(_ range: ClosedRange<Int>) -> SubSequence {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound)
        return self[start ... end]
    }

    subscript(_ range: Range<Int>) -> SubSequence {
        let start = index(startIndex, offsetBy: range.first!)
        let end = index(startIndex, offsetBy: range.last!)
        return self[start ... end]
    }

    subscript(_ i: Int) -> Character {
        self[index(startIndex, offsetBy: i)]
    }

}

