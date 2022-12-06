//
// Created by Aleksy Krolczyk on 06/12/2022.
//

import Foundation

class Day06: AdventDay {
    let signal: String

    required init(_ data: String) {
        signal = data
    }

    private func findDistinctIndex(length: Int ) -> Int {
        for i in 0 ... (signal.count - 1) - (length - 1) {
            let slice = signal[i ... i + (length - 1)]
            if Set(slice).count == length {
                return i + length
            }
        }
        return -1
    }

    func part1() {
        print(findDistinctIndex(length: 4))
    }

    func part2() {
        print(findDistinctIndex(length: 14))
    }


}
