//
//  SkinShipVC.swift
//  NewGame
//
//  Created by Алина Андрушок on 08.03.2023.
//

import UIKit

class SkinShipVC: UIViewController {
    
    let closeButton = ButtonFactory.createButton(imageName: "xmark.circle")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        
        settingsCloseButton()
    }
    
    func settingsCloseButton() {
        closeButton.addTarget(self, action: #selector(closeWindow), for: .touchUpInside)
        
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40)
            ])
       
    }
    
    
    @objc func closeWindow() {
        self.dismiss(animated: true)
    }
}
