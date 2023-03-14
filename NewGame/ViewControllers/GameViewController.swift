//
//  GameViewController.swift
//  NewGame
//
//  Created by Алина Андрушок on 21.02.2023.
//

import UIKit
import SpriteKit
import GameplayKit


enum ImageName{
    
    case musicEffectsOn, musicEffectsOff, backgroundMusicOn, backgroundMusicOff, vibrationOn, vibrationOff
    
    var name: String {
        switch self {
        case .musicEffectsOn: return "speaker.wave.1.fill"
        case .musicEffectsOff: return "speaker.fill"
        case .backgroundMusicOn: return "music.note.list"
        case .backgroundMusicOff: return "music.note"
        case .vibrationOn: return "iphone.gen3.radiowaves.left.and.right"
        case .vibrationOff: return "iphone.gen3"
        }
    }
}



class GameViewController: UIViewController {
    
    let musicControl = MusicManager.shared
    let defaults = UserDefaultManager.shared
    let vibration = VibrationManager.shared
    
    var imageForMusicEffectsButton = UserDefaultManager.shared.musicEffectsIsOn ? "speaker.wave.1.fill" : "speaker.fill"
    var imageBackgroundMusicButton = UserDefaultManager.shared.backgroundMusicIsOn ? "music.note.list" : "music.note"
    var imageForvibrationButton = UserDefaultManager.shared.vibrationIsOn ? "iphone.gen3.radiowaves.left.and.right" : "iphone.gen3"
    
    let settingsButton = ButtonFactory.createButton(imageName: "gearshape")
    let changeBackgoundButton = ButtonFactory.createButton(imageName: "mountain.2.fill")
    let changeSkinShipButton = ButtonFactory.createButton(imageName: "car.top.radiowaves.front.fill")
    lazy var musicEffectsButton = ButtonFactory.createButton(imageName: imageForMusicEffectsButton)
    lazy var backgroundMusicButton = ButtonFactory.createButton(imageName: imageBackgroundMusicButton)
    lazy var vibrationButton = ButtonFactory.createButton(imageName: imageForvibrationButton)
    
    
    
    
    var effectsControlButtonsArray: [UIButton]?
    
    let stackViewSkin = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
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
            vibrationButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),

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
    
    func changeImageOnButton(button: UIButton, isOn: Bool, imageNameButtonON: ImageName, imageNameButtonOff: ImageName) {
        let imageName = isOn ? imageNameButtonON.name : imageNameButtonOff.name
        let configImage = UIImage.SymbolConfiguration(pointSize: 23, weight: .regular, scale: .large)
        button.setImage(UIImage(systemName: imageName, withConfiguration: configImage), for: .normal)
        button.imageView?.tintColor = #colorLiteral(red: 0, green: 0.9802040458, blue: 1, alpha: 1)
    }
    
    @objc func settingsButtonTapped() {
        vibration.tapOnButton()
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
        vibration.tapOnButton()
        musicControl.soundEffects(fileName: "click")
        let vc = ImagePickerVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.arrayImageForPicker = [
            UIImage(named: "background1")!,
            UIImage(named: "background2")!,
            UIImage(named: "background3")!,
            UIImage(named: "background4")!,
            UIImage(named: "background5")!,
            UIImage(named: "background6")!
        ]
        vc.multiplierForWidthAnchor = 0.8
        vc.multiplierForHeightAnchor = 0.6
        present(vc, animated: true)
        print("changeBackgoundButtonTapped")
    }
    
    @objc func changeSkinShipButtonTapped() {
        vibration.tapOnButton()
        musicControl.soundEffects(fileName: "click")
        let vc = ImagePickerVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.arrayImageForPicker = [
            UIImage(named: "ship1")!,
            UIImage(named: "ship2")!,
            UIImage(named: "ship3")!,
            UIImage(named: "ship4")!,
            UIImage(named: "ship5")!,
            UIImage(named: "ship6")!
        ]
        vc.multiplierForWidthAnchor = 0.5
        vc.multiplierForHeightAnchor = 0.3
        vc.callBack = { str in
            
        }
        present(vc, animated: true)
        print("changeSkinShipButtonTapped")
    }
    
    @objc func musicEffectsButtonTapped() {
        vibration.tapOnButton()
        defaults.musicEffectsIsOn.toggle()
        changeImageOnButton(button: musicEffectsButton,
                            isOn: defaults.musicEffectsIsOn,
                            imageNameButtonON: ImageName.musicEffectsOn,
                            imageNameButtonOff: ImageName.musicEffectsOff
        )
        musicControl.soundEffects(fileName: "click")
        print("musicEffectsButtonTapped")
    }
    
    @objc func backgroundMusicButtonTapped() {
        vibration.tapOnButton()
        defaults.backgroundMusicIsOn.toggle()
        changeImageOnButton(button: backgroundMusicButton,
                            isOn: defaults.backgroundMusicIsOn,
                            imageNameButtonON: ImageName.backgroundMusicOn,
                            imageNameButtonOff: ImageName.backgroundMusicOff
        )
        musicControl.soundEffects(fileName: "click")
        musicControl.playBackgroundMusic()
        print("backgroundMusicButtonTapped")
    }
    
    @objc func vibrationButtonTapped() {
        defaults.vibrationIsOn.toggle()
        changeImageOnButton(button: vibrationButton,
                            isOn: defaults.vibrationIsOn,
                            imageNameButtonON: ImageName.vibrationOn,
                            imageNameButtonOff: ImageName.vibrationOff)
        vibration.tapOnButton()
        musicControl.soundEffects(fileName: "click")
        print("vibrationButtonTapped")
    }
}
