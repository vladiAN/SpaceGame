//
//  MusicManager.swift
//  NewGame
//
//  Created by Алина Андрушок on 02.03.2023.
//

import AVFoundation

class MusicManager {
    
    private init() {}
    
    static let shared = MusicManager()
    
    var audioPlayer: AVAudioPlayer?
    var soundEffectsDict: [String: AVAudioPlayer] = [:]
    
    
    
    func playBackgroundMusic() {
        let backgroundMusicIsActive = UserDefaultManager.shared.backgroundMusic
        if backgroundMusicIsActive {
            if let bundle = Bundle.main.path(forResource: "background-music", ofType: "mp3") {
                let backgroundMusic = NSURL(fileURLWithPath: bundle)
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: backgroundMusic as URL)
                    guard let audioPlayer = audioPlayer else { return }
                    audioPlayer.numberOfLoops = -1
                    audioPlayer.play()
                } catch {
                    print("Cloud not load background music file")
                }
            }
        } else {
            audioPlayer?.stop()
            audioPlayer = nil
        }
    }
    
    func stopbackgroundMusic() {
        
    }
    
    func loadSoundEffects() {
        
        let soundEffectsFiles = [
            "shot",
            "ballDrop",
            "ballSeparation",
            "click"
        ]
        
        for file in soundEffectsFiles {
            if let soundURL = Bundle.main.url(forResource: file, withExtension: "mp3") {
                do {
                    let soundEffect = try AVAudioPlayer(contentsOf: soundURL)
                    soundEffectsDict[file] = soundEffect
                } catch {
                    print("Error loading sound effect file: \(file)")
                }
            } else {
                print("Error loading sound effect file: \(file)")
            }
        }
    }
    
    func soundEffects(fileName: String) {
        let musicEffectIsActive = UserDefaultManager.shared.musicEffects
        print(musicEffectIsActive)
        if musicEffectIsActive {
            if let sound = soundEffectsDict[fileName] {
                sound.currentTime = 0
                sound.play()
            }
        } else { return }
    }
    
}
