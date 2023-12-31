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
        for i in 0..<size {
            var nodeArr = [Node]()
            for j in 0..<size {
                nodeArr.append(Node(state: .defaultState, row: i, col: j))
            }
            self.nodes.append(nodeArr)
        }
    }
    
    func clear() {
        startIndex = nil
        targetIndex = nil
        for nodesRow in nodes {
            for node in nodesRow {
                node.state = .defaultState
                node.manhattanDistance = Int.max
                node.heuristicDistance = Int.max
                node.fullDistance = Int.max
            }
        }
    }
    
    func generate() {
        clear()
        
        startIndex = (Int.random(in: 0..<size), Int.random(in: 0..<size))
        targetIndex = (Int.random(in: 0..<size), Int.random(in: 0..<size))
        
        guard var startIndex, let targetIndex else {
            return
        }
        
        while startIndex == targetIndex {
            startIndex = (Int.random(in: 0..<size), Int.random(in: 0..<size))
        }
        
        nodes[startIndex.0][startIndex.1].state = .start
        nodes[targetIndex.0][targetIndex.1].state = .target
        
        for i in 0..<size {
            for j in 0..<size {
                if nodes[i][j].state != .start && nodes[i][j].state != .target {
                    if Int.random(in: 0...10) < 4 {
                        nodes[i][j].state = .blocked
                    }
                }
            }
        }
    }
    
    func clearPath() {
        for nodesRow in nodes {
            for node in nodesRow {
                if node.state == .path || node.state == .visited {
                    node.state = .defaultState
                }
            }
        }
    }
    
    func printGraph() {
        for i in 0..<size {
            for j in 0..<size {
                print("\(nodes[i][j].state) (\(i), \(j)) ", separator: "", terminator: "")
            }
            print()
        }
    }
}

class Node {
    var state: NodeStates
    let row: Int
    let col: Int
    var fullDistance = Int.max
    var manhattanDistance = Int.max
    var heuristicDistance = Int.max
    
    init(state: NodeStates, row: Int, col: Int) {
        self.state = .defaultState
        self.row = row
        self.col = col
    }
    
    func configureState() {
        
    }
}

enum NodeStates {
    case defaultState
    case start
    case target
    case blocked
    case path
    case visited
}
