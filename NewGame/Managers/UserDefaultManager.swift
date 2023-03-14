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
    private let backgroundImageKey = "imageBackground"
    private let skinShipImageKey = "skinShip"
    
    private init() {
        defaults.register(defaults: [
            musicEffectsKey : true,
            backgroundMusicKey : true,
            vibrationKey : true,
            backgroundImageKey : "background1",
            skinShipImageKey : "ship1"
            
        ])
    }
    
    
    var musicEffectsIsOn: Bool {
        get {
            defaults.bool(forKey: musicEffectsKey)
        }
        set {
            defaults.set(newValue, forKey: musicEffectsKey)
        }
    }
    
    var backgroundMusicIsOn: Bool {
        get {
            defaults.bool(forKey: backgroundMusicKey)
        }
        set {
            defaults.set(newValue, forKey: backgroundMusicKey)
        }
    }
    
    var vibrationIsOn: Bool {
        get {
            defaults.bool(forKey: vibrationKey)
        }
        set {
            defaults.set(newValue, forKey: vibrationKey)
        }
    }
    
}
