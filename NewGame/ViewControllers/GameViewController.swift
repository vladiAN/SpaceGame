//
//  GameViewController.swift
//  NewGame
//
//  Created by Алина Андрушок on 21.02.2023.
//

import UIKit
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    let musicControl = MusicManager.shared
    let defaults = UserDefaultManager.shared
    let vibration = VibrationManager.shared
    
    var backgroundImage = UIImageView()
    
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
    let scoreLabel = UILabel()
    
    let scene = GameScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setScene()
        
    }
    
    func setScene() {
        
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
        
        let skView = SKView(frame: view.frame)
        self.view.addSubview(skView)
        
        
        scene.scoreCallBack = { [weak self] score in
            self?.scoreLabel.text = "Score: \(score)"
        }
        
        scene.scaleMode = .aspectFill
        scene.backgroundColor = .clear
        skView.presentScene(scene)
        
        skView.allowsTransparency = true
        skView.ignoresSiblingOrder = true
//        skView.showsFPS = true
//        skView.showsNodeCount = true
//        skView.showsPhysics = true
        
        musicControl.loadSoundEffects()
        musicControl.playBackgroundMusic()
        
        effectsControlButtonsArray = [musicEffectsButton, backgroundMusicButton, vibrationButton]
        effectsControlButtonsArray?.forEach { (btn) in
            btn.isHidden = true
        }
        
        scene.restartCallBack = { [weak self] in
            self?.setScene()
        }
        
        settingsTargetButton()
        setttingstackViewSkin()
        setBackground()
        setupLabel()
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(stackViewSkin)
        view.addSubview(musicEffectsButton)
        view.addSubview(backgroundMusicButton)
        view.addSubview(vibrationButton)
        settingsConstraint()
    }
    
    func setBackground() {
        
        if let backgroundImageName = UserDefaults.standard.string(forKey: "imageBackground") {
            backgroundImage = UIImageView(image: UIImage(named: backgroundImageName))
            let scaleY = view.frame.size.height / backgroundImage.frame.size.height
            backgroundImage.frame.size = CGSize(width: backgroundImage.frame.size.width * scaleY, height: view.frame.height)
            view.insertSubview(backgroundImage, at: 0)
        }
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
            
            scoreLabel.centerYAnchor.constraint(equalTo: stackViewSkin.centerYAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    func setupLabel() {
        scoreLabel.font = .init(name: "Menlo-Italic", size: 25)
        scoreLabel.text = "Score: 0"
        scoreLabel.textColor = settingsButton.imageView?.tintColor
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
       
        view.addSubview(scoreLabel)
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
        scene.isPaused = true
        let vc = ImagePickerVC()
        vc.gameVC = self
        vc.modalPresentationStyle = .overFullScreen
        vc.strs = ["background1", "background2", "background3", "background4", "background5", "background6"]
        vc.callBack = { str in
            self.setBgString(imageName: str)
            self.backgroundImage.removeFromSuperview()
            self.setBackground()
        }
        vc.multiplierForWidthAnchor = 0.8
        vc.multiplierForHeightAnchor = 0.6
        present(vc, animated: true)
        print("changeBackgoundButtonTapped")
    }
    
    func setBgString(imageName: String) {
        UserDefaults.standard.set(imageName, forKey: "imageBackground")
    }
    
    @objc func changeSkinShipButtonTapped() {
        vibration.tapOnButton()
        musicControl.soundEffects(fileName: "click")
        scene.isPaused = true
        let vc = ImagePickerVC()
        vc.gameVC = self
        vc.modalPresentationStyle = .overFullScreen
        vc.strs = ["ship1", "ship2", "ship3", "ship4", "ship5", "ship6"]
        vc.multiplierForWidthAnchor = 0.7
        vc.multiplierForHeightAnchor = 0.4
        vc.callBack = { str in
            self.setShipSkin(imageName: str)
            self.scene.starShip.texture = SKTexture(imageNamed: str)
            UserDefaults.standard.set(str, forKey: "skinShip")
        }
        
        present(vc, animated: true)
        print("changeSkinShipButtonTapped")
    }
    
    func setShipSkin(imageName: String) {
        UserDefaults.standard.set(imageName, forKey: "skinShip")
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
