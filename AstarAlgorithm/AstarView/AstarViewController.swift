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
    var algorithmPicker: UIPickerView!
    var nodeButtons = [[nodeButton]]()
    var selectedIndexes: [IndexPath] = [IndexPath(row: 0, section: 0)]
    var graph = Graph(withSize: 10)
    var counter = 1.0
    lazy var dfs = DFSSearch(graph: graph)
    
    var algorithms = ["Astar", "DFS", "BFS"]
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //        printMatrix()
        //        graph.printGraph()
        
        view.backgroundColor = .white
        
        algorithmNameLabel = UILabel()
        algorithmNameLabel.translatesAutoresizingMaskIntoConstraints = false
        algorithmNameLabel.textAlignment = .center
        algorithmNameLabel.font = UIFont.systemFont(ofSize: 22)
        algorithmNameLabel.text = "Astar Search"
        view.addSubview(algorithmNameLabel)
        
        algorithmPicker = UIPickerView()
        algorithmPicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(algorithmPicker)
        algorithmPicker.delegate = self
        algorithmPicker.dataSource = self
        
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
            var nodeButtonsRow = [nodeButton]()
            for col in 0..<graph.size {
                let node = nodeButton(row: row, section: col, selectedState: .defaultstate)
                node.buttonTapped = { [unowned self] in
                    configureButtonState(node: node)
                }
                //                node.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                //                node.setTitle("\(row), \(col)", for: .normal)
                //                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                //                node.frame = frame
                //                node.backgroundColor = .white
                //                node.layer.cornerRadius = 5
                //                node.layer.borderWidth = 1
                //                node.layer.borderColor = UIColor.black.cgColor
                //                node.setTitleColor(.clear, for: .normal)
                
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
            
            algorithmPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            algorithmPicker.topAnchor.constraint(equalTo: algorithmNameLabel.bottomAnchor, constant: -40),
            
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
        graph.clearPath()
        updateGraphView()
        let path = dfs.search()
        if path.isEmpty || graph.targetIndex == nil || path.last! != graph.targetIndex! {
            print("target is not reachable form start")
        }
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        print(path)
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        updateGraphView()
        animateOrange(path: path)
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
    
    func configureButtonState(node: nodeButton) {
        if node.selectedState == .start {
            node.selectedState = .defaultstate
            graph.startIndex = nil
            graph.nodes[node.row][node.section].isStart = false
        } else if node.selectedState == .target {
            node.selectedState = .defaultstate
            graph.targetIndex = nil
            graph.nodes[node.row][node.section].isTarget = false
        } else {
            if graph.startIndex == nil {
                node.selectedState = .start
                graph.startIndex = (node.row, node.section)
                graph.nodes[node.row][node.section].isStart = true
            } else if graph.targetIndex == nil {
                node.selectedState = .target
                graph.targetIndex = (node.row, node.section)
                graph.nodes[node.row][node.section].isTarget = true
            } else {
                if node.selectedState == .defaultstate {
                    node.selectedState = .blocked
                    graph.nodes[node.row][node.section].isBlocked = true
                } else {
                    node.selectedState = .defaultstate
                    graph.nodes[node.row][node.section].isBlocked = false
                }
            }
        }
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
        
        //        print("\(currentIndex) \(graph.nodes[currentIndex.0][currentIndex.1].isBlocked)")
    }
    
    private func getIndex(title: String) -> (Int, Int)? {
        guard let i = title.first?.wholeNumberValue,
              let j = title.last?.wholeNumberValue
        else {
            return nil
        }
        return (i, j)
    }
    
    func animateOrange(path: [(Int, Int)]) {
        for (i, j) in path {
            nodeButton.animate(withDuration: 1, delay: 1) {
                self.nodeButtons[i][j].backgroundColor = .orange
            }
        }
    }
    
    func updateGraphView() {
        for i in 0..<graph.size {
            for j in 0..<graph.size {
                if graph.nodes[i][j].isBlocked {
                    nodeButtons[i][j].selectedState = .blocked
                } else if graph.nodes[i][j].isStart {
                    nodeButtons[i][j].selectedState = .start
                } else if graph.nodes[i][j].isTarget {
                    nodeButtons[i][j].selectedState = .target
                } else if graph.nodes[i][j].isPath {
                    nodeButtons[i][j].selectedState = .visited
                } else {
                    nodeButtons[i][j].selectedState = .defaultstate
                }
                
                nodeButtons[i][j].buttonStateConfigure()
                
            }
        }
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return algorithms.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        algorithms[row]
    }
}

class nodeButton: UIButton {
    
    let row: Int
    let section: Int
    var selectedState: selectedButtonStates
    var buttonTapped: (() -> ())?
    
    init(row: Int, section: Int, selectedState: selectedButtonStates) {
        self.row = row
        self.section = section
        self.selectedState = selectedState
        super.init(frame: .zero)
        configureUI()
        buttonStateConfigure()
    }
    func configureUI() {
        titleLabel?.font = UIFont.systemFont(ofSize: 16)
        frame = CGRect(x: section * 25, y: row * 25, width: 25, height: 25)
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        setTitleColor(.clear, for: .normal)
        addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    func buttonStateConfigure() {
        switch selectedState {
        case .defaultstate:
            backgroundColor = .white
        case .start:
            backgroundColor = .green
        case .target:
            backgroundColor = .red
        case .blocked:
            backgroundColor = .purple
        case .path:
            backgroundColor = .orange
        case .visited:
            self.backgroundColor = .yellow
        }
    }
    
    @objc func didTapButton() {
        buttonTapped?()
        buttonStateConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum selectedButtonStates {
    case defaultstate
    case start
    case target
    case blocked
    case path
    case visited
}
