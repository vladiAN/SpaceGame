//
//  ButtonFactory.swift
//  NewGame
//
//  Created by Алина Андрушок on 06.03.2023.
//

import Foundation
import UIKit

class ButtonFactory {
    static func createButton(imageName: String) -> UIButton {
        let button = UIButton()
        let configImage = UIImage.SymbolConfiguration(pointSize: 23, weight: .regular, scale: .large)
        button.setImage(UIImage(systemName: imageName, withConfiguration: configImage), for: .normal)
        button.imageView?.tintColor = #colorLiteral(red: 0.01476755552, green: 0.9785382152, blue: 1, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
}
