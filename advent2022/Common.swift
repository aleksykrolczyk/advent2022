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

