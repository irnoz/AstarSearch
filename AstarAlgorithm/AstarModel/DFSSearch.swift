//
//  DFSSearch.swift
//  AstarAlgorithm
//
//  Created by User on 29.11.23.
//

import Foundation

class DFSSearch {
    var graph: Graph
    
    init(graph: Graph) {
        self.graph = graph
    }

    // Initialize direction vectors
    let dRow = [0, 1, 0, -1]
    let dCol = [-1, 0, 1, 0]

    // Function to check if graph[row][col]
    // is unvisited and lies within the
    // boundary of the given matrix
    private func isValid(node current: (Int, Int)) -> Bool {
        let row = current.0
        let col = current.1
        
        // If node is out of bounds
        if row < 0 || col < 0 || row >= graph.size || col >= graph.size {
            return false
        }

        // If the node is already visited
        if graph.nodes[row][col].state == .visited || graph.nodes[row][col].state == .blocked {
            return false
        }

        return true
    }
    
    private func DFS(from start: (Int, Int), to target: (Int, Int), in graph: [[Node]]) -> [(Int, Int)]{
        // Initialize a stack of tuples and
        // push the starting cell into it
        var stack = [start]
        var path = [(Int, Int)]()

        // Iterate until the
        // stack is not empty
        while !stack.isEmpty {
            // Pop the top tuple
            let current = stack.removeLast()
            let row = current.0
            let col = current.1

            // Check if the current popped
            // node is a valid cell or not
            if !isValid(node: current) {
                continue
            }

            // Mark the current
            // node as visited
            if (current != target && current != start) {
                graph[row][col].state = .visited
                path.append(current)
            }

            // Push all the adjacent 
            // nodes in stack
            for i in 0..<4 {
                let adjx = row + dRow[i]
                let adjy = col + dCol[i]
                stack.append((adjx, adjy))
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
        path = DFS(from: start, to: target, in: graph.nodes)
        return path
    }
}


struct Stack<T> {
    private var items: [T] = []
    
    var isEmpty: Bool {
        return items.isEmpty
    }
    
    func peek() -> T {
        guard let topElement = items.last else {
            fatalError("This stack is empty.")
        }
        return topElement
    }
    
    mutating func pop() -> T {
        guard !items.isEmpty else {
            fatalError("This stack is empty.")
        }
        return items.removeLast()
    }
  
    mutating func push(_ element: T) {
        items.append(element)
    }
}
