//
//  GameViewController.swift
//  NewGame
//
//  Created by Алина Андрушок on 21.02.2023.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    let settingsButton: UIButton = {
        let button = UIButton()
        let configImage = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .large)
        button.setImage(UIImage(systemName: "gearshape", withConfiguration: configImage), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
            view.backgroundColor = UIColor(named: "background")
        }
        
        setupUI()

    }
//
//    func createButton(imageIcon: String) -> UIButton {
//        let button = UIButton()
//        let configImage = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .large)
//        button.setImage(UIImage(systemName: imageIcon, withConfiguration: configImage), for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }
     
    func setupUI() {
        view.addSubview(settingsButton)
        
        
        settingsConstraint()
    }
    
    func settingsConstraint() {
        
        NSLayoutConstraint.activate([
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            settingsButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
    }
    
    
    @objc func settingsButtonTapped() {
        print("settingsButtonTapped")
    }
    
}
