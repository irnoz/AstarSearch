//
//  BFSSearch.swift
//  AstarAlgorithm
//
//  Created by User on 01.12.23.
//

import Foundation

class BFSSearch {
    var graph: Graph
    
    init(graph: Graph) {
        self.graph = graph
    }
    
    // Initialize direction vectors
    let dRow = [0, 1, 0, -1]
    let dCol = [-1, 0, 1, 0]
    
    private func isValid(node current: (Int, Int)) -> Bool {
        let row = current.0
        let col = current.1
        
        // Make sure cell is in bounds
        if row < 0 || col < 0 || row >= graph.size || col >= graph.size {
            return false
        }
        
        // Make sure cell is not yet viesited
        if graph.nodes[row][col].state == .visited || graph.nodes[row][col].state == .blocked {
            return false
        }
        
        return true
    }
    
    private func BFS(from start: (Int, Int), to target: (Int, Int), in graph: [[Node]]) -> [(Int, Int)]{
        // Initialise path and queue
        var path = [(Int, Int)]()
        var queue = Queue<(Int, Int)>()
        
        // add start to queue
        queue.enqueue(start)
        
        // Iterate until the
        // queue is empty
        while !queue.isEmpty {
            // Get and remove first
            // element from queue
            guard let current = queue.dequeue() else {
                return path
            }
            
            // Check if the current
            // popped cell is valid
            if !isValid(node: current) {
                continue
            }
            
            let row = current.0
            let col = current.1
            
            // Mark the current
            // cell as visited
            if (current != target && current != start) {
                graph[row][col].state = .visited
                path.append(current)
            }
            
            // Print the element at
            // the current top cell
//            print("\(row), \(col): \(graph[row][col].state) ", terminator: "")
            
            // Add all adjacent
            // elements to queue
            for i in 0..<4 {
                let adjx = row + dRow[i]
                let adjy = col + dCol[i]
                
                queue.enqueue((adjx, adjy))
                
                if (adjx, adjy) == target {
                    return path
                }
            }
        }
        return path
    }
    
    func search() -> [(Int, Int)] {
        var path = [(Int, Int)]()
        guard let start = graph.startIndex,
              let target = graph.targetIndex
        else {
            return path
        }
        path = BFS(from: start, to: target, in: graph.nodes)
        return path
    }
}


struct Queue<T> {
    private var elements: [T] = []
    
    mutating func enqueue(_ value: T) {
        elements.append(value)
    }
    
    mutating func dequeue() -> T? {
        guard !elements.isEmpty else {
            return nil
        }
        return elements.removeFirst()
    }
    
    var head: T? {
        return elements.first
    }
    
    var tail: T? {
        return elements.last
    }
    
    var isEmpty: Bool {
        return elements.isEmpty
    }
}
