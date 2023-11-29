//
//  AstarView.swift
//  AstarAlgorithm
//
//  Created by User on 28.11.23.
//

import UIKit

class AstarView: UIView {
    let algorithmNameLabel: UILabel = {
        let algorithmNameLabel = UILabel()
        algorithmNameLabel.translatesAutoresizingMaskIntoConstraints = false
        algorithmNameLabel.textAlignment = .center
        algorithmNameLabel.font = UIFont.systemFont(ofSize: 22)
        algorithmNameLabel.text = "Astar Search"
        return algorithmNameLabel
    }()
    
    let startButton: UIButton = {
        let startButton = UIButton(type: .system)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.setTitle("Start", for: .normal)
//        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return startButton
    }()
    
    let clearButton: UIButton = {
        let clearButton = UIButton(type: .system)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.setTitle("Clear", for: .normal)
//        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        return clearButton
    }()
    
    let generateGraphButton: UIButton = {
        let generateGraphButton = UIButton(type: .system)
        generateGraphButton.translatesAutoresizingMaskIntoConstraints = false
        generateGraphButton.setTitle("Generate", for: .normal)
//        generateGraphButton.addTarget(self, action: #selector(generateButtonTapped), for: .touchUpInside)
        return generateGraphButton
    }()
    
    init() {
        super.init(frame: .zero)
//        setup(with: <#Graph#>)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        setup(with: <#T##Graph#>)
    }
    
    func setup(with graph: Graph) {
        
    }
}
