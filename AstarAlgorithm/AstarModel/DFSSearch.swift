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
    func isValid(_ row: Int, _ col: Int) -> Bool {
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
    func DFS(from start: (Int, Int), to target: (Int, Int),_ row: Int, _ col: Int, _ grid: [[Node]]) {
        // Initialize a stack of tuples and
        // push the starting cell into it
        
        var stack = [(row, col)]

        // Iterate until the
        // stack is not empty
        while !stack.isEmpty{
            // Pop the top tuple
            let curr = stack.removeLast()
            let row = curr.0
            let col = curr.1
            
            if curr == target {
                break
            }
            

            // Check if the current popped
            // cell is a valid cell or not
            if !isValid(row, col) {
                continue
            }

            // Mark the current
            // cell as visited
            
            graph.nodes[row][col].isPath = true

            // Print the element at
            // the current top cell
            print("\(row), \(col): \(grid[row][col].isPath) ", terminator: "")

            // Push all the adjacent cells
            for i in 0..<4 {
                let adjx = row + dRow[i]
                let adjy = col + dCol[i]
                stack.append((adjx, adjy))
                if (adjx, adjy) == target {
                    return
                }
            }
        }
    }

    // Stores whether the current
    // cell is visited or not
    

    // Function call
    func search() {
        guard let start = graph.startIndex,
              let target = graph.targetIndex
        else {
            return
        }
        DFS(from: start, to: target, graph.startIndex!.0, graph.startIndex!.1, graph.nodes)
    }
}
