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
    
    let defaults = UserDefaultManager.shared
    
    var bgAudioPlayer: AVAudioPlayer?
    var shotAudioPlayer: AVAudioPlayer?
    var soundEffectsDict: [String: AVAudioPlayer] = [:]
    
    
    
    func playBackgroundMusic() {
        if defaults.backgroundMusicIsOn {
            if let bundle = Bundle.main.path(forResource: "background-music", ofType: "mp3") {
                let backgroundMusic = NSURL(fileURLWithPath: bundle)
                do {
                    bgAudioPlayer = try AVAudioPlayer(contentsOf: backgroundMusic as URL)
                    guard let audioPlayer = bgAudioPlayer else { return }
                    audioPlayer.numberOfLoops = -1
                    audioPlayer.play()
                } catch {
                    print("Cloud not load background music file")
                }
            }
        } else {
            bgAudioPlayer?.stop()
            bgAudioPlayer = nil
        }
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
        if defaults.musicEffectsIsOn {
            if let sound = soundEffectsDict[fileName] {
                sound.currentTime = 0
                sound.play()
            }
        } else { return }
    }
    
    func shotEffects() {
        if defaults.musicEffectsIsOn {
            if let bundle = Bundle.main.path(forResource: "shot", ofType: "mp3") {
                let shot = NSURL(fileURLWithPath: bundle)
                do {
                    shotAudioPlayer = try AVAudioPlayer(contentsOf: shot as URL)
                    guard let audioPlayer = shotAudioPlayer else { return }
                    audioPlayer.numberOfLoops = -1
                    audioPlayer.play()
                } catch {
                    print("Cloud not load background music file")
                }
            }
        } else { return }
        
    }
    
    func shotEffectsStop() {
        shotAudioPlayer?.stop()
        shotAudioPlayer = nil
    }

}
