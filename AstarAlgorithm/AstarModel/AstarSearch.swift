//
//  AstarSearch.swift
//  AstarAlgorithm
//
//  Created by User on 28.11.23.
//

import Foundation

class AstarSearch {
    var graph: Graph
    
    init(graph: Graph) {
        self.graph = graph
    }

    // Initialize direction vectors
    let dRow = [0, 1, 0, -1]
    let dCol = [-1, 0, 1, 0]
    
    // function to Check if node
    // is within graph bounds
    private func isValid(node current: (Int, Int)) -> Bool {
        let row = current.0
        let col = current.1
        
        // If cell is out of bounds
        if row < 0 || col < 0 || row >= graph.size || col >= graph.size {
            return false
        }

        // If the cell is already visited
        if graph.nodes[row][col].state == .visited || graph.nodes[row][col].state == .blocked {
            return false
        }

        return true
    }
    
    // Check if cell is out of bounds
    private func isInBounds(row: Int, col: Int) -> Bool {
        if row < 0 || col < 0 || row >= graph.size || col >= graph.size {
            return false
        }
        return true
    }
    
    private func calculateManhattanDistance(from target: (Int, Int), to current: (Int, Int)) -> Int {
        return (abs(target.0 - current.0) + abs(target.1 - current.1)) * 10
    }
    
    private func setHeuristicDistance(from target: (Int, Int), in graph: [[Node]]) {
        let size = graph.count
        for i in 0..<size {
            for j in 0..<size {
                graph[i][j].heuristicDistance = calculateManhattanDistance(from: target, to: (i, j))
            }
        }
    }
    
    private func aStarSearch(from start: (Int, Int), to target: (Int, Int), in graph: [[Node]]) -> [(Int, Int)] {
        var path: [(Int, Int)] = []
        
        setHeuristicDistance(from: target, in: graph)
        
        return path
    }
    
    func search() -> [(Int, Int)] {
        var path = [(Int, Int)]()
        guard let start = graph.startIndex,
              let target = graph.targetIndex
        else {
            return path
        }
        
        path = aStarSearch(from: start, to: target, in: graph.nodes)
        printHdistancesMatrix()
        
        return path
    }
    
    func printHdistancesMatrix() {
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        for nodesRow in graph.nodes {
            for node in nodesRow {
                print("\(node.heuristicDistance) ", separator: "", terminator: "")
            }
            print("")
        }
    }
}
