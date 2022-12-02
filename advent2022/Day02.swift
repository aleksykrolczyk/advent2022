//
// Created by Aleksy Krolczyk on 02/12/2022.
//

import Foundation

fileprivate let WIN = 6
fileprivate let TIE = 3
fileprivate let LOSS = 0

fileprivate struct Round {
    let op: Shape
    let me: Shape
}

fileprivate enum Shape {
    case rock, paper, scissors

    init?(_ letter: Character?) {
        switch letter {
        case "A", "X": self = .rock
        case "B", "Y": self = .paper
        case "C", "Z": self = .scissors
        default: return nil
        }
    }

    var score: Int {
        switch self {
        case .rock: return 1
        case .paper: return 2
        case .scissors: return 3
        }
    }

    var losesTo: Shape {
        switch self {
        case .rock: return .paper
        case .paper: return .scissors
        case .scissors: return .rock
        }
    }

    var winsOver: Shape {
        switch self {
        case .rock: return .scissors
        case .paper: return .rock
        case .scissors: return .paper
        }
    }

}

class Day02: AdventDay {
    fileprivate let rounds: [Round]

    required init(_ data: String) {
        var _rounds: [Round] = []
        data.enumerateLines { line, _ in
            _rounds.append(
                Round(op: Shape(line.first)!, me: Shape(line.last)!)
            )
        }
        rounds = _rounds
    }

    func part1() {
        var score = 0
        rounds.forEach { round in
            if round.me == round.op {
                score += TIE
            }
            else if round.me.winsOver == round.op {
                score += WIN
            }
            score += round.me.score
        }

        print(score)
    }

    func part2() {
        var score = 0
        rounds.forEach { round in
            switch round.me {
            case .rock: // x - lose
                score += round.op.winsOver.score + LOSS
            case .paper: // y - tie
                score += round.op.score + TIE
            case .scissors: // z - win
                score += round.op.losesTo.score + WIN
            }
        }
        print(score)
    }
}
