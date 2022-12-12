//
// Created by Aleksy Krolczyk on 12/12/2022.
//

import Foundation

fileprivate let START = 0
fileprivate let END = Int(Character("z").asciiValue! - Character("a").asciiValue!)

fileprivate struct Coords: Hashable, CustomStringConvertible, Equatable {
    var description: String {
        "(\(x), \(y))"
    }
    
    let x: Int
    let y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

class Day12: AdventDay {

    var grid: [[Int]]
    fileprivate var start: Coords = Coords(x: -1, y: -1)
    fileprivate var end: Coords = Coords(x: -1, y: -1)
    fileprivate var distMatrix: [[Int]]
    fileprivate var unvisited: Set<Coords> = Set()
    
    required init(_ data: String) {
        grid = data.components(separatedBy: "\n").filter { !$0.isEmpty }.map { line in
            Array(line.map { Int($0.asciiValue!) - Int(Character("a").asciiValue!) })
        }
        for i in grid.indices {
            for j in grid[i].indices {
                unvisited.insert(Coords(x: i, y: j))
                if grid[i][j] == -14 {
                    start = Coords(x: i, y: j)
                    grid[i][j] = START
                }
                if grid[i][j] == -28 {
                    end = Coords(x: i, y: j)
                    grid[i][j] = END
                }
            }
        }
        distMatrix = Array(repeating: Array(repeating: 99999, count: grid[0].count), count: grid.count)
    }

    fileprivate func dijkstra(start: Coords, forward: Bool = true) {
        var current: Coords? = start
        distMatrix[start] = 0
        while current != nil {
            unvisited.remove(current!)
            for neighbor in grid.neighbors(current!.x, current!.y) {
                if grid[current!] - grid[neighbor] >= -1 {
                    distMatrix[neighbor] = min(distMatrix[neighbor], distMatrix[current!] + 1)
                }
            }
            current = unvisited.min(by: { distMatrix[$0] < distMatrix[$1] })
        }
    }
    
    func part1() {
        dijkstra(start: start)
        print(distMatrix[end])
    }

    func part2() {
        distMatrix = Array(repeating: Array(repeating: 99999, count: grid[0].count), count: grid.count)
        for i in grid.indices {
            for j in grid[i].indices {
                grid[i][j] = abs(grid[i][j] - END)
                unvisited.insert(Coords(x: i, y: j))
            }
        }
        dijkstra(start: end)
        
        var minDist = Int.max
        for i in grid.indices {
            for j in grid[i].indices {
                if grid[i][j] == END {
                    minDist = min(minDist, distMatrix[i][j])
                }
            }
        }
        
        print(minDist)
    }
}

fileprivate extension [[Int]] {
    func matrixPrint() {
        for row in self {
            print(row)
        }
    }
    
    subscript(_ c: Coords) -> Int {
        get { self[c.x][c.y]            }
        set { self[c.x][c.y] = newValue }
    }
    
    func neighbors(_ i: Int, _ j: Int) -> [Coords] {
        var res: [Coords] = []
        if i - 1 >= 0 {
            res.append(Coords(x: i - 1, y: j - 0))
        }
        
        if i + 1 <= self.count - 1 {
            res.append(Coords(x: i + 1, y: j - 0))
        }
        
        if j - 1 >= 0 {
            res.append(Coords(x: i - 0, y: j - 1))
        }
        
        if j + 1 <= self[i].count - 1 {
            res.append(Coords(x: i - 0, y: j + 1))
        }
        
        return res
    }
}
