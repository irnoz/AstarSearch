//
//  ViewController.swift
//  AstarAlgorithm
//
//  Created by User on 27.11.23.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Properties
    var algorithmNameLabel: UILabel!
    var tagPicker: UIPickerView!
    var nodeButtons = [[UIButton]]()
    var selectedIndexes: [IndexPath] = [IndexPath(row: 0, section: 0)]
    var graph = Graph(withSize: 10)
    
    var things = ["chose start", "chose end", "chose block"]
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        printMatrix()
        graph.printGraph()
        
        view.backgroundColor = .white
        
        algorithmNameLabel = UILabel()
        algorithmNameLabel.translatesAutoresizingMaskIntoConstraints = false
        algorithmNameLabel.textAlignment = .center
        algorithmNameLabel.font = UIFont.systemFont(ofSize: 22)
        algorithmNameLabel.text = "Astar Search"
        view.addSubview(algorithmNameLabel)
        
        tagPicker = UIPickerView()
        tagPicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tagPicker)
        tagPicker.delegate = self
        tagPicker.dataSource = self
        
        let startButton = UIButton(type: .system)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.setTitle("Start", for: .normal)
        view.addSubview(startButton)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        let clearButton = UIButton(type: .system)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.setTitle("Clear", for: .normal)
        view.addSubview(clearButton)
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        
        let generateGraphButton = UIButton(type: .system)
        generateGraphButton.translatesAutoresizingMaskIntoConstraints = false
        generateGraphButton.setTitle("Generate", for: .normal)
        view.addSubview(generateGraphButton)
        generateGraphButton.addTarget(self, action: #selector(generateButtonTapped), for: .touchUpInside)
        
        let nodesView = UIView()
        nodesView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nodesView)
        
        let width = 25
        let height = 25
        
        for row in 0..<graph.size{
            var nodeButtonsRow = [UIButton]()
            for col in 0..<graph.size {
                let node = UIButton(type: .system)
                node.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                node.setTitle("\(row), \(col)", for: .normal)
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                node.frame = frame
                node.backgroundColor = .white
                node.layer.cornerRadius = 5
                node.layer.borderWidth = 1
                node.layer.borderColor = UIColor.black.cgColor
                node.setTitleColor(.clear, for: .normal)
                
                nodesView.addSubview(node)
                
                node.addTarget(self, action: #selector(nodeTapped), for: .touchUpInside)
                nodeButtonsRow.append(node)
            }
            nodeButtons.append(nodeButtonsRow)
        }
        
        func handelButtonTap(selectedIndex: (Int, Int)) {
            print(selectedIndex)
        }
        
        NSLayoutConstraint.activate([
            algorithmNameLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 16),
            algorithmNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tagPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tagPicker.topAnchor.constraint(equalTo: algorithmNameLabel.bottomAnchor, constant: -40),
            
            nodesView.widthAnchor.constraint(equalToConstant: CGFloat(graph.size * width)),
            nodesView.heightAnchor.constraint(equalToConstant: CGFloat(graph.size * height)),
            nodesView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nodesView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            clearButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -8),
            clearButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 16),
            
            startButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -8),
            startButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -16),
            
            generateGraphButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -8),
            generateGraphButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    // MARK: Methods
    @objc func startButtonTapped(_ sender: UIButton) {
        
    }
    
    @objc func clearButtonTapped(_ sender: UIButton) {
        graph.clear()
        updateGraphView()
    }
    
    @objc func generateButtonTapped(_ sender: UIButton) {
        graph.clear()
        graph.generate()
        updateGraphView()
    }
    
    
    @objc func nodeTapped(_ sender: UIButton) {
        guard let titleLabel = sender.titleLabel?.text,
              let currentIndex = getIndex(title: titleLabel) else {
            return
        }
        if sender.backgroundColor == .green {
            sender.backgroundColor = .white
            graph.startIndex = nil
            graph.nodes[currentIndex.0][currentIndex.1].isStart = true
        } else if sender.backgroundColor == .red {
            sender.backgroundColor = .white
            graph.targetIndex = nil
            graph.nodes[currentIndex.0][currentIndex.1].isStart = false
        } else {
            if graph.startIndex == nil {
                sender.backgroundColor = .green
                graph.startIndex = currentIndex
                graph.nodes[currentIndex.0][currentIndex.1].isTarget = true
            } else if graph.targetIndex == nil {
                sender.backgroundColor = .red
                graph.targetIndex = currentIndex
                graph.nodes[currentIndex.0][currentIndex.1].isTarget = false
            } else {
                if sender.backgroundColor == .white {
                    sender.backgroundColor = .purple
                    graph.nodes[currentIndex.0][currentIndex.1].isBlocked = true
                } else {
                    sender.backgroundColor = .white
                    graph.nodes[currentIndex.0][currentIndex.1].isBlocked = false
                }
            }
        }
        
        print("\(currentIndex) \(graph.nodes[currentIndex.0][currentIndex.1].isBlocked)")
    }
    
    private func getIndex(title: String) -> (Int, Int)? {
        guard let i = title.first?.wholeNumberValue,
                let j = title.last?.wholeNumberValue
        else {
            return nil
        }
        return (i, j)
    }
    
    func updateGraphView() {
        for i in 0..<graph.size {
            for j in 0..<graph.size {
                if graph.nodes[i][j].isBlocked {
                    nodeButtons[i][j].backgroundColor = .purple
                } else if graph.nodes[i][j].isStart {
                    nodeButtons[i][j].backgroundColor = .green
                } else if graph.nodes[i][j].isTarget {
                    nodeButtons[i][j].backgroundColor = .red
                } else {
                    nodeButtons[i][j].backgroundColor = .white
                }
            }
        }
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return things.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        things[row]
    }
}

