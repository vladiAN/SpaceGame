//
//  VibrationManager.swift
//  NewGame
//
//  Created by Алина Андрушок on 08.03.2023.
//

import UIKit

class VibrationManager {
    
    private init() {}
    
    static let shared = VibrationManager()
    
    let defaults = UserDefaultManager.shared
    
    func tapOnButton() {
        if defaults.vibrationIsOn{
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
    }
    
    func destroyedPlanet() {
        if defaults.vibrationIsOn {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
    }
    
}
