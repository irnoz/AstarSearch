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
                nodeArr.append(Node(state: .defaultState))
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
            }
        }
//        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
//        printGraph()
//        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    }
    
    func generate() {
        clear()
        
        startIndex = (Int.random(in: 0..<size), Int.random(in: 0..<size))
        targetIndex = (Int.random(in: 0..<size), Int.random(in: 0..<size))
        
        guard let startIndex, let targetIndex else {
            return
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
//        printGraph()
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
    var fullDistance = Int.max
    var heuristicDistance = Int.max
    
    init(state: NodeStates) {
        self.state = .defaultState
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
