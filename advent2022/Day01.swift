//
// Created by Aleksy Krolczyk on 02/12/2022.
//

import Foundation

class Day01: AdventDay {
    let elvesToCalories: [Int]

    required init(_ data: String) {
        var index = 0
        var temp: [Int] = [0]
        data.enumerateLines { (line, _) in
            if !line.isEmpty {
                temp[index] += Int(line)!
            } else {
                temp.append(0)
                index += 1
            }
        }

        elvesToCalories = temp

    }
    func part1() {
        print(elvesToCalories.max()!)
    }

    func part2() {
        let sum = elvesToCalories.sorted { $0 > $1 }[0...2].reduce(0, +)
        print(sum)
    }
}