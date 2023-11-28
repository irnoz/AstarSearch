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
    var nodes = [UIButton]()
    var selectedIndexes: [IndexPath] = [IndexPath(row: 0, section: 0)]
    var startIndex: (Int, Int)? = nil
    var targetIndex: (Int, Int)? = nil
    var graph = Array(repeating: Array(repeating: 1, count: 5), count: 5)
    var selectedIndex: (Int, Int)? = nil
    
    var things = ["chose start", "chose end", "chose block"]
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        printMatrix()
        
        tagPicker.delegate = self
        tagPicker.dataSource = self
        
        view = UIView()
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
        
        let width = 50
        let height = 50
        
        for row in 0..<graph.count {
            for col in 0..<graph.count {
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
                nodes.append(node)
            }
        }
        
        func handelButtonTap(selectedIndex: (Int, Int)) {
            print(selectedIndex)
        }
        
        NSLayoutConstraint.activate([
            algorithmNameLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 16),
            algorithmNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tagPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tagPicker.topAnchor.constraint(equalTo: algorithmNameLabel.bottomAnchor, constant: -40),
            
            nodesView.widthAnchor.constraint(equalToConstant: CGFloat(5 * width)),
            nodesView.heightAnchor.constraint(equalToConstant: CGFloat(5 * height)),
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
        
    }
    
    @objc func generateButtonTapped(_ sender: UIButton) {
        
    }
    
    
    @objc func nodeTapped(_ sender: UIButton) {
        guard let titleLabel = sender.titleLabel?.text,
              let currentIndex = getIndex(title: titleLabel) else {
            return
        }
        if sender.backgroundColor == .green {
            sender.backgroundColor = .white
            startIndex = nil
        } else if sender.backgroundColor == .red {
            sender.backgroundColor = .white
            targetIndex = nil
        } else {
            if startIndex == nil {
                sender.backgroundColor = .green
                startIndex = currentIndex
            } else if targetIndex == nil {
                sender.backgroundColor = .red
                targetIndex = currentIndex
            } else {
                sender.backgroundColor = sender.backgroundColor == .white ? .purple : .white
            }
        }
        
        print(currentIndex)
        
    }
    
    private func getIndex(title: String) -> (Int, Int)? {
        guard let i = title.first?.wholeNumberValue,
                let j = title.last?.wholeNumberValue
        else {
            return nil
        }
        return (i, j)
    }
    
    private func printMatrix() {
        for arr in graph {
            for el in arr {
                print("\(el) ", separator: " ", terminator: "")
            }
            print()
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

