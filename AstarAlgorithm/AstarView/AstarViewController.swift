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
    var nodeButtons = [[NodeButton]]()
    var selectedIndexes: [IndexPath] = [IndexPath(row: 0, section: 0)]
    var counter = 1.0

    lazy var dfs = DFSSearch(graph: graph)
    lazy var bfs = BFSSearch(graph: graph)
    lazy var aStar = AstarSearch(graph: graph)

    var algorithms = ["Astar", "DFS", "BFS"]

    var graph = {
        let device = UIDevice.current.userInterfaceIdiom
        let size: Int
        switch device {
        case .phone:
            size = 10
        case .pad:
            size = 25
        case .tv:
            size = 100
        default:
            size = 10
        }
        return Graph(withSize: size)
    }() // Graph(withSize: 10) // 25
    
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
        algorithmNameLabel.text = "Pathfinding algorithms"
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
            var nodeButtonsRow = [NodeButton]()
            for col in 0..<graph.size {
                let node = NodeButton(row: row, section: col, selectedState: .defaultState)
                node.buttonTapped = { [unowned self] in
                    configureButtonState(node: node)
                }
                
                nodesView.addSubview(node)
//                node.addTarget(self, action: #selector(nodeTapped), for: .touchUpInside)
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
        nukeAllAnimations()
        updateGraphView()
        
        let alg = algorithmPicker.selectedRow(inComponent: 0)
        var path: [(Int, Int)] = []
        switch alg {
        case 1:
            path = dfs.search()
        case 2:
            path = bfs.search()
        default:
            path = aStar.search()
        }
        
        if path.isEmpty || path.last! != graph.targetIndex! {
            print("target is not reachable form start")
        }
        updateGraphView()
        trace(path: path)
    }
    
    @objc func clearButtonTapped(_ sender: UIButton) {
        nukeAllAnimations()
        graph.clear()
        updateGraphView()
    }
    
    @objc func generateButtonTapped(_ sender: UIButton) {
        nukeAllAnimations()
        graph.clear()
        graph.generate()
        updateGraphView()
    }
    
    func configureButtonState(node: NodeButton) {
        if node.selectedState == .start {
            node.selectedState = .defaultState
            graph.startIndex = nil
            graph.nodes[node.row][node.section].state = .defaultState
        } else if node.selectedState == .target {
            node.selectedState = .defaultState
            graph.targetIndex = nil
            graph.nodes[node.row][node.section].state = .defaultState
        } else {
            if graph.startIndex == nil {
                node.selectedState = .start
                graph.startIndex = (node.row, node.section)
                graph.nodes[node.row][node.section].state = .start
            } else if graph.targetIndex == nil {
                node.selectedState = .target
                graph.targetIndex = (node.row, node.section)
                graph.nodes[node.row][node.section].state = .target
            } else {
                if node.selectedState == .defaultState {
                    node.selectedState = .blocked
                    graph.nodes[node.row][node.section].state = .blocked
                } else {
                    node.selectedState = .defaultState
                    graph.nodes[node.row][node.section].state = .defaultState
                }
            }
        }
    }
    
//    @objc func nodeTapped(_ sender: NodeButton) {
//        guard let titleLabel = sender.titleLabel?.text,
//              let currentIndex = getIndex(title: "1, 1"/*titleLabel*/) else {
//            return
//        }
//        
//        configureButtonState(node: sender)
//    }
    
    func nukeAllAnimations() {
        for buttonsRow in nodeButtons {
            for button in buttonsRow {
                button.layer.removeAllAnimations()
            }
        }
    }
    
    func trace(path: [(Int, Int)]) {
        var k = 0.0
        for (i, j) in path {
            k += 1
            UIView.animate(withDuration: 0.3, delay: TimeInterval(k*0.2)) {
                self.nodeButtons[i][j].backgroundColor = .orange
            }
        }
//        setColorFromHeuristics()
    }
    
    func setColorFromHeuristics() {
        for i in 0..<graph.size {
            for j in 0..<graph.size {
                if (i, j) != graph.startIndex! && (i, j) != graph.targetIndex! {
                    nodeButtons[i][j].backgroundColor = .blue
                    nodeButtons[i][j].layer.opacity = 1.0 / Float(graph.nodes[i][j].fullDistance) * 6
                }
            }
        }
    }
    
    func updateGraphView() {
        for i in 0..<graph.size {
            for j in 0..<graph.size {
                UIView.performWithoutAnimation {
                    nodeButtons[i][j].selectedState = graph.nodes[i][j].state
                    
                    nodeButtons[i][j].buttonStateConfigure()
                }
                
//                print(nodeButtons[i][j].selectedState, graph.nodes[i][j].state)
            }
        }
    }
}

// MARK: - Picker Extension
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

class NodeButton: UIButton {
    let row: Int
    let section: Int
    var selectedState: NodeStates
    var buttonTapped: (() -> ())?
    
    init(row: Int, section: Int, selectedState: NodeStates) {
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
        case .defaultState:
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
