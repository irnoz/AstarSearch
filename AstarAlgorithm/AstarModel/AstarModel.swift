//
//  AstarModel.swift
//  AstarAlgorithm
//
//  Created by User on 28.11.23.
//

import Foundation

class Graph {
    var startIndex: (Int, Int)? = nil
    var targetIndex: (Int, Int)? = nil
    var size: Int
    var nodes: [[Node]] = [[Node]]()
    
    init(withSize size: Int = 10) {
        self.size = size
        for _ in 0..<size {
            var nodeArr = [Node]()
            for _ in 0..<size {
              nodeArr.append(Node())
            }
            self.nodes.append(nodeArr)
        }
    }
    
    func clear() {
        startIndex = nil
        targetIndex = nil
        for nodesRow in nodes {
            for node in nodesRow {
                node.isBlocked = false
                node.isStart = false
                node.isTarget = false
            }
        }
    }
    
    func generate() {
        clear()
        
        startIndex = (Int.random(in: 0..<size), Int.random(in: 0..<size))
        targetIndex = (Int.random(in: 0..<size), Int.random(in: 0..<size))
        
        guard let startIndex,
              let targetIndex
        else { 
            return
        }
        
        nodes[startIndex.0][startIndex.1].isStart = true
        nodes[targetIndex.0][targetIndex.1].isTarget = true
        for i in 0..<size {
            for j in 0..<size {
                if !nodes[i][j].isStart && !nodes[i][j].isTarget {
                    nodes[i][j].isBlocked = (Int.random(in: 0...10) < 4)
                }
            }
        }
    }
    
    func printGraph() {
        for arr in nodes {
            for node in arr {
                print("\(node.isBlocked) ", separator: " ", terminator: "")
            }
            print()
        }
    }
}

class Node {
    var isBlocked: Bool = false
    var isStart: Bool = false
    var isTarget: Bool = false
    func toggle() {
        self.isBlocked = !isBlocked
    }
}
