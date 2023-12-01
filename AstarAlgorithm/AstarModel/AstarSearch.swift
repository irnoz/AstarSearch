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
    
    private func setEucledeanDistance(from start: (Int, Int), to target: (Int, Int), in graph: [[Node]]) {
        
    }
    
    private func setManhattanDistance(from start: (Int, Int), to target: (Int, Int), in graph: [[Node]]) {
        
    }
    
    private func aStarSearch(from start: (Int, Int), to target: (Int, Int), in graph: [[Node]]) -> [(Int, Int)] {
        var path: [(Int, Int)] = []
        
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
        return path
    }
}
