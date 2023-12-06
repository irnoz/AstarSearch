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
        return (abs(target.0 - current.0) + abs(target.1 - current.1))
    }
    
    private func setManhattanDistance(from start: (Int, Int), in graph: [[Node]]) {
        let size = graph.count
        for i in 0..<size {
            for j in 0..<size {
                if isValid(node: (i, j)) {
                    graph[i][j].manhattanDistance = calculateManhattanDistance(from: start, to: (i, j))
                    graph[i][j].fullDistance = graph[i][j].heuristicDistance + graph[i][j].manhattanDistance
                }
            }
        }
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
        // initialise path and heap
        var path: [(Int, Int)] = []
        var heap: Heap<Node> = .init(elements: [graph[start.0][start.1]], priorityFunction: {
            $0.fullDistance < $1.fullDistance
        })
        
        // Set heuristic distance
        // from target to each node
        setHeuristicDistance(from: target, in: graph)
        setManhattanDistance(from: start, in: graph)
        
        // Set real distance to start
        graph[start.0][start.1].manhattanDistance = 0
        graph[start.0][start.1].fullDistance = graph[start.0][start.1].heuristicDistance
        
        while !heap.isEmpty {
            
            for element in heap.elements {
                print(element.fullDistance, terminator: " ")
            }
            print(heap.peek()?.fullDistance)
            guard let current = heap.dequeue() else {
                return path
            }
            let row = current.row
            let col = current.col
            let currentIndex = (row, col)
            
            if !isValid(node: (row, col)) {
                continue
            }
            
            // Mark the current
            // cell as visited
            if (currentIndex != target && currentIndex != start) {
                graph[row][col].state = .visited
                path.append(currentIndex)
            }
            
            // Add all adjacent
            // elements to heap
            for i in 0..<4 {
                let adjx = row + dRow[i]
                let adjy = col + dCol[i]
                
                if isValid(node: (adjx, adjy)) {
                    //                    graph[adjx][adjy].fullDistance = graph[adjx][adjy].heuristicDistance + graph[adjx][adjy].manhattanDistance
                    heap.enqueue(graph[adjx][adjy])
                }
                
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
        
        path = aStarSearch(from: start, to: target, in: graph.nodes)
        printHdistancesMatrix()
        printMdistancesMatrix()
        printFdistancesMatrix()
        
        return path
    }
    
    func printHdistancesMatrix() {
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Heuristic!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        for nodesRow in graph.nodes {
            for node in nodesRow {
                print("\(node.heuristicDistance) ", separator: "", terminator: "")
            }
            print("")
        }
    }
    
    func printMdistancesMatrix() {
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Manhattan!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        for nodesRow in graph.nodes {
            for node in nodesRow {
                print("\(node.manhattanDistance) ", separator: "", terminator: "")
            }
            print("")
        }
    }
    
    func printFdistancesMatrix() {
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!Full!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        for nodesRow in graph.nodes {
            for node in nodesRow {
                print("\(node.fullDistance) ", separator: "", terminator: "")
            }
            print("")
        }
    }
}

struct Heap<Element> {
    var elements: [Element]
    let priorityFunction: (Element, Element) -> Bool
    
    init(elements: [Element] = [], priorityFunction: @escaping (Element, Element) -> Bool) {
        self.elements = elements
        self.priorityFunction = priorityFunction
        
        buildHeap()
    }
    
    mutating func buildHeap() {
        for index in (0 ..< count / 2).reversed() {
            siftDown(elementAtIndex: index)
        }
    }
    
    var isEmpty: Bool {
        return elements.isEmpty
    }
    
    var count: Int {
        return elements.count
    }
    
    func peek() -> Element? {
        return elements.first
    }
    
    func isRoot(_ index: Int) -> Bool {
        return (index == 0)
    }
    
    func leftChildIndex(of index: Int) -> Int {
        return (2 * index) + 1
    }
    
    func rightChildIndex(of index: Int) -> Int {
        return (2 * index) + 2
    }
    
    func parentIndex(of index: Int) -> Int {
        return (index - 1) / 2
    }
    
    func isHigherPriority(at firstIndex: Int, than secondIndex: Int) -> Bool {
        return priorityFunction(elements[firstIndex], elements[secondIndex])
    }
    
    func highestPriorityIndex(of parentIndex: Int, and childIndex: Int) -> Int {
        guard childIndex < count && isHigherPriority(at: childIndex, than: parentIndex) else {
            return parentIndex
        }
        
        return childIndex
    }
    
    func highestPriorityIndex(for parent: Int) -> Int {
        return highestPriorityIndex(
            of: highestPriorityIndex(
                of: parent,
                and: leftChildIndex(of: parent)),
            and: rightChildIndex(of: parent))
    }
    
    mutating func swapElement(at firstIndex: Int, with secondIndex: Int) {
        guard firstIndex != secondIndex else { return }
        elements.swapAt(firstIndex, secondIndex)
    }
    
    // enqueue element
    mutating func enqueue(_ element: Element) {
        elements.append(element)
        siftUp(elementAtIndex: count - 1)
    }
    
    mutating func siftUp(elementAtIndex index: Int) {
        let parent = parentIndex(of: index)
        guard !isRoot(index),
              isHigherPriority(at: index, than: parent)
        else { return }
        swapElement(at: index, with: parent)
        siftUp(elementAtIndex: parent)
    }
    
    // dequeue element
    mutating func dequeue() -> Element? {
        guard !isEmpty else { return nil }
        swapElement(at: 0, with: count - 1)
        
        let element = elements.removeLast()
        
        if !isEmpty {
            siftDown(elementAtIndex: 0)
        }
        return element
    }
    
    mutating func siftDown(elementAtIndex index: Int) {
        let childIndex = highestPriorityIndex(for: index)
        if index == childIndex {
            return
        }
        
        swapElement(at: index, with: childIndex)
        siftDown(elementAtIndex: childIndex)
    }
}
