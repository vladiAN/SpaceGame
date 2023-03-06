//
//  UserDefaultManager.swift
//  NewGame
//
//  Created by Алина Андрушок on 06.03.2023.
//

import Foundation

class UserDefaultManager {
        
    static let shared = UserDefaultManager()
    let defaults = UserDefaults.standard
    
    private let musicEffectsKey = "musicEffects"
    private let backgroundMusicKey = "backgroundMusic"
    private let vibrationKey = "vibration"
    
    private init() {
        UserDefaults.standard.register(defaults: [
            musicEffectsKey : true,
            backgroundMusicKey : true,
            vibrationKey : true
        ])
    }
    
    
    var musicEffects: Bool {
        get {
            defaults.bool(forKey: musicEffectsKey)
        }
        set {
            defaults.set(newValue, forKey: musicEffectsKey)
        }
    }
    
    var backgroundMusic: Bool {
        get {
            defaults.bool(forKey: backgroundMusicKey)
        }
        set {
            defaults.set(newValue, forKey: backgroundMusicKey)
            
        }
    }
    
}
