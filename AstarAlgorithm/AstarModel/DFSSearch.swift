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

    // Function to check if mat[row][col]
    // is unvisited and lies within the
    // boundary of the given matrix
    func isValid(node current: (Int, Int)) -> Bool {
        let row = current.0
        let col = current.1
        
        // If cell is out of bounds
        if row < 0 || col < 0 || row >= graph.size || col >= graph.size {
            return false
        }

        // If the cell is already visited
        if graph.nodes[row][col].isPath || graph.nodes[row][col].isBlocked {
            return false
        }

        // Otherwise, it can be visited
        return true
    }

    // Function to perform DFS
    // Traversal on the matrix grid[]
    func DFS(from start: (Int, Int), to target: (Int, Int), in graph: [[Node]]) -> [(Int, Int)]{
        // Initialize a stack of tuples and
        // push the starting cell into it
        var stack = [start]
        var path = [(Int, Int)]()

        // Iterate until the
        // stack is not empty
        while !stack.isEmpty{
            // Pop the top tuple
            let current = stack.removeLast()
            let row = current.0
            let col = current.1

            // Check if the current popped
            // cell is a valid cell or not
            if !isValid(node: current) {
                continue
            }

            // Mark the current
            // cell as visited
            graph[row][col].isPath = true
            path.append(current)

            // Print the element at
            // the current top cell
            print("\(row), \(col): \(graph[row][col].isPath) ", terminator: "")

            // Push all the adjacent cells
            for i in 0..<4 {
                let adjx = row + dRow[i]
                let adjy = col + dCol[i]
                stack.append((adjx, adjy))
                if (adjx, adjy) == target {
                    path.removeFirst()
                    return path
                }
            }
        }
        path.removeFirst()
        return path
    }

    // Function call
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
