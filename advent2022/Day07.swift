//
// Created by Aleksy Krolczyk on 06/12/2022.
//

import Foundation

fileprivate let MAX_SIZE = 100000
fileprivate let AVAILABLE_SPACE = 70000000
fileprivate let REQUIRED_SPACE = 30000000

fileprivate protocol FileType {
    var name: String { get }
    var size: Int { get }

    func prettyPrint(indent: Int) -> Void
}

fileprivate struct File: FileType {
    let name: String
    let size: Int

    func prettyPrint(indent: Int = 0) {
        print("\(String(repeatElement(" ", count: indent)))\(name) \(size) (file)")
    }
}


fileprivate class Directory: FileType {
    let name: String
    let parent: Directory?
    var children: [String: FileType] = [:]

    var size: Int {
        // terrible redundancy of computations, lets goooooo
        children.reduce(0, { $0 + $1.value.size })
    }

    init(name: String, parent: Directory?) {
        self.name = name
        self.parent = parent
    }

    func prettyPrint(indent: Int = 0) {
        print("\(String(repeatElement(" ", count: indent)))\(name) \(size) (dir)")
        children.forEach { child in
            child.value.prettyPrint(indent: indent + 1)
        }
    }

    func sizeOfdirsBelowSize() -> Int {
        let x = size < MAX_SIZE ? size : 0

        let childDirs = children.values.compactMap { $0 as? Directory}
        if childDirs.count == 0 {
            return x
        }
        return x + childDirs.reduce(0, { $0 + $1.sizeOfdirsBelowSize()})
    }

    func sizeOfDirToDelete(unusedSpace: Int) -> Int? {
        let x = unusedSpace + size > REQUIRED_SPACE ? size : nil

        let childDirs = children.values.compactMap { $0 as? Directory }
        if childDirs.count == 0 {
            return x
        }

        let eligibleChildren = childDirs.compactMap { $0.sizeOfDirToDelete(unusedSpace: unusedSpace) }
        let childMin = eligibleChildren.reduce(Int.max, min)
        return x != nil ? min(x!, childMin) : childMin

    }
}


class Day07: AdventDay {

    fileprivate var root: Directory = Directory(name: "/", parent: nil)

    required init(_ data: String) {
        var currentDir  = root

        data.enumerateLines { line, _ in
            switch line[0] {
            case "$":
                if !line.contains("cd") {
                    break
                }
                let destination = String(line.split(separator: " ").last!)
                switch destination {
                case "/":
                    currentDir = self.root
                case "..":
                    currentDir = currentDir.parent!
                default:
                    currentDir = currentDir.children[destination] as! Directory
                }
            case "d":
                let newDir = String(line.split(separator: " ").last!)
                currentDir.children[newDir] = Directory(name: newDir, parent: currentDir)
            default:
                let args = line.split(separator: " ")
                let name = String(args[1])
                let size = Int(args[0])!
                currentDir.children[name] = File(name: name, size: size)
            }
        }
//        root.prettyPrint()
    }

    func part1() {
        print(root.sizeOfdirsBelowSize())
    }

    func part2() {
        print(root.sizeOfDirToDelete(unusedSpace: AVAILABLE_SPACE - root.size)!)
    }


}
