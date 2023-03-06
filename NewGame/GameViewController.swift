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
    
    let musicControl = MusicManager.shared
    
    let settingsButton = ButtonFactory.createButton(imageName: "gearshape")
    let changeBackgoundButton = ButtonFactory.createButton(imageName: "mountain.2.fill")
    let changeSkinShipButton = ButtonFactory.createButton(imageName: "car.top.radiowaves.front.fill")
    var musicEffectsButton = ButtonFactory.createButton(imageName: "speaker.wave.1.fill") // TODO: speaker.fill - musicEffects off
    let backgroundMusicButton = ButtonFactory.createButton(imageName: "music.note.list") // TODO: music.note - music off
    let vibrationButton = ButtonFactory.createButton(imageName: "iphone.gen3.radiowaves.left.and.right") //TODO: iphone.gen3 - vibro off
    
    var effectsControlButtonsArray: [UIButton]?
    
    let stackViewSkin = UIStackView()

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
        
        musicControl.loadSoundEffects()
        musicControl.playBackgroundMusic()
        
        effectsControlButtonsArray = [musicEffectsButton, backgroundMusicButton, vibrationButton]
        effectsControlButtonsArray?.forEach { (btn) in
            btn.isHidden = true
        }
        
        settingsTargetButton()
        setttingstackViewSkin()
        setupUI()

    }

    func setupUI() {
        view.addSubview(stackViewSkin)
        view.addSubview(musicEffectsButton)
        view.addSubview(backgroundMusicButton)
        view.addSubview(vibrationButton)
        settingsConstraint()
    }
    
    func settingsTargetButton() {
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        changeBackgoundButton.addTarget(self, action: #selector(changeBackgoundButtonTapped), for: .touchUpInside)
        changeSkinShipButton.addTarget(self, action: #selector(changeSkinShipButtonTapped), for: .touchUpInside)
        musicEffectsButton.addTarget(self, action: #selector(musicEffectsButtonTapped), for: .touchUpInside)
        backgroundMusicButton.addTarget(self, action: #selector(backgroundMusicButtonTapped), for: .touchUpInside)
        vibrationButton.addTarget(self, action: #selector(vibrationButtonTapped), for: .touchUpInside)
    }

    func settingsConstraint() {
        NSLayoutConstraint.activate([
            stackViewSkin.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackViewSkin.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            musicEffectsButton.topAnchor.constraint(equalTo: stackViewSkin.bottomAnchor, constant: 10),
            musicEffectsButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            backgroundMusicButton.topAnchor.constraint(equalTo: musicEffectsButton.bottomAnchor, constant: 10),
            backgroundMusicButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            vibrationButton.topAnchor.constraint(equalTo: backgroundMusicButton.bottomAnchor, constant: 10),
            vibrationButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),

        ])
    }
    
    func setttingstackViewSkin() {
        stackViewSkin.axis = .horizontal
        stackViewSkin.spacing = 10
        stackViewSkin.alignment = .center
        stackViewSkin.distribution = .fill
        stackViewSkin.translatesAutoresizingMaskIntoConstraints = false
        
        stackViewSkin.addArrangedSubview(settingsButton)
        stackViewSkin.addArrangedSubview(changeBackgoundButton)
        stackViewSkin.addArrangedSubview(changeSkinShipButton)
    }
    
    @objc func settingsButtonTapped() {
        musicControl.soundEffects(fileName: "click")
        print("settingsButtonTapped")
        effectsControlButtonsArray?.forEach { (btn) in
            UIView.animate(withDuration: 2) {
                btn.isHidden = !btn.isHidden
                btn.layoutIfNeeded()
            }
        }
    }
    
    @objc func changeBackgoundButtonTapped() {
        musicControl.soundEffects(fileName: "click")
        print("changeBackgoundButtonTapped")
    }
    
    @objc func changeSkinShipButtonTapped() {
        musicControl.soundEffects(fileName: "click")
        print("changeSkinShipButtonTapped")
    }
    
    @objc func musicEffectsButtonTapped() {
        UserDefaultManager.shared.musicEffects.toggle()
        musicControl.soundEffects(fileName: "click")
        print("musicEffectsButtonTapped")
    }
    
    @objc func backgroundMusicButtonTapped() {
        UserDefaultManager.shared.backgroundMusic.toggle()
        musicControl.soundEffects(fileName: "click")
        musicControl.playBackgroundMusic()
        print("backgroundMusicButtonTapped")
    }
    
    @objc func vibrationButtonTapped() {
        MusicManager.shared.soundEffects(fileName: "click")
        print("vibrationButtonTapped")
    }
}
