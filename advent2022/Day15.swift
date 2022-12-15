//
// Created by Aleksy Krolczyk on 15/12/2022.
//

import Foundation

fileprivate protocol HasPosition {
    var pos: Point { get }
}

fileprivate struct Beacon: HasPosition, Hashable {
    let pos: Point
}

fileprivate struct Line {
    let a: Int
    let b: Int

}

fileprivate struct Sensor: HasPosition {
    let pos: Point
    let nearestBeacon: Beacon
    let manhattanRadius: Int

    let lines: (tl: Line, tr: Line, bl: Line, br: Line)

    init(pos: Point, nearestBeacon: Beacon) {
        self.pos = pos
        self.nearestBeacon = nearestBeacon
        manhattanRadius = abs(pos.x - nearestBeacon.pos.x) + abs(pos.y - nearestBeacon.pos.y)
        lines = (
            tl: Line(a: 1, b: (pos.y - pos.x) + manhattanRadius),
            tr: Line(a: -1, b: (pos.y + pos.x) + manhattanRadius),
            bl: Line(a: -1, b: (pos.y + pos.x) - manhattanRadius),
            br: Line(a: 1, b: (pos.y - pos.x) - manhattanRadius)
        )
    }

    func pointsInRange(forY y: Int) -> ClosedRange<Int>? {
        let dx = manhattanRadius - abs(pos.y - y)
        if dx <= 0 { return nil }
        return pos.x - dx ... pos.x + dx
    }
}

class Day15: AdventDay {
    fileprivate let sensors: [Sensor]

    required init(_ data: String) {
        let regex = try! NSRegularExpression(pattern: #"(x|y)=(-?\d+)"#)
        var _sensors: [Sensor] = []
        data.components(separatedBy: "\n").forEach { line in
            let matches = regex.matches(in: line, range: NSRange(line.startIndex ..< line.endIndex, in: line))
            let nums = matches.map { match in
                let range = Range(match.range(at: 2), in: line)!
                return Int(line[range])!
            }
            let beacon = Beacon(pos: Point(x: nums[2], y: nums[3]))
            _sensors.append(Sensor(pos: Point(x: nums[0], y: nums[1]), nearestBeacon: beacon))
        }
        sensors = _sensors
        print(sensors)
    }

    func part1() {
        var uniqueHorizontalPos: Set<Int> = []
        let y = 2000000
        for sensor in sensors {
            let x = sensor.pointsInRange(forY: y)
            if let x = x {
                for i in x { uniqueHorizontalPos.insert(i) }
            }
        }
        let beaconsInRange = Set(
                sensors
                        .filter { $0.nearestBeacon.pos.y == Int(y) && uniqueHorizontalPos.contains($0.nearestBeacon.pos.x)}
                        .map { $0.nearestBeacon}
        )
        print(uniqueHorizontalPos.count - beaconsInRange.count)
    }

    func part2() {
        for i in 0 ... sensors.count - 1 {
            for j in 0 ... sensors.count - 1 {
                for q in 0 ... sensors.count - 1 {
                    for p in 0 ... sensors.count - 1 {
                        if Set([i, j, q, p]).count != 4 { continue }
                        if (sensors[i].lines.bl.b - sensors[j].lines.tr.b == 2) && (sensors[q].lines.br.b - sensors[p].lines.tl.b == 2) {
                            let c = sensors[j].lines.tr.b + 1
                            let b = sensors[p].lines.tl.b + 1
                            let x = (c - b) / 2
                            let y = -x + c
                            print(x * 4000000 + y)
                        }
                    }
                }
            }
        }
    }
}



fileprivate struct Point: CustomStringConvertible, Hashable {
    let x: Int
    let y: Int

    var description: String { "(\(x), \(y))" }
}

extension Sensor: CustomStringConvertible {
    var description: String {
        "<S: \(pos), r=\(manhattanRadius), nearestBeacon: \(nearestBeacon.pos)>"
    }
}

fileprivate extension Numeric {
    var sqr: Self { self * self }
}
