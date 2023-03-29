//
//  BackGroundImageVC.swift
//  NewGame
//
//  Created by Алина Андрушок on 08.03.2023.
//

import UIKit

class ImagePickerVC: UIViewController {

    weak var gameVC: GameViewController?
    
    let buttonSelect: UIButton = {
        let buttonSelect = UIButton()
        buttonSelect.backgroundColor = #colorLiteral(red: 0, green: 0.9785962701, blue: 1, alpha: 1)
        buttonSelect.layer.cornerRadius = 5
        buttonSelect.setTitle("SELECT", for: .normal)
        buttonSelect.setTitleColor(.black, for: .normal)
        buttonSelect.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonSelect
    }()
    
    var strs: [String] = []
    lazy var arrayImageForPicker: [UIImage] = {
        strs.compactMap { UIImage(named: $0) }
    }()
    let backgroundImage: UIImage? = nil
    let shipSkinImage: UIImage? = nil
    var multiplierForWidthAnchor = 0.5
    var multiplierForHeightAnchor = 0.3
    
    
    var callBack: ((String) -> ())?
    
    let viewUnderButton: UIView = {
            let viewUnderButton = UIView()
            viewUnderButton.backgroundColor = .clear
            return viewUnderButton
        }()
    
    let bigStackImage = UIStackView()
    var arrayButtonImage: [UIButton] = []
    var imageView = UIImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        
        setupStackImage()
        settingsCloseButton()
        redBorderBTouch()
       
    }

    
    func settingsCloseButton() {
        buttonSelect.addTarget(self, action: #selector(closeWindow), for: .touchUpInside)
        
        viewUnderButton.addSubview(buttonSelect)
        
        NSLayoutConstraint.activate([
            buttonSelect.centerXAnchor.constraint(equalTo: viewUnderButton.centerXAnchor),
            buttonSelect.centerYAnchor.constraint(equalTo: viewUnderButton.centerYAnchor),
            ])
    }
    
    @objc func closeWindow() {
        MusicManager.shared.soundEffects(fileName: "click")
        self.dismiss(animated: true)

        gameVC?.scene.isPaused = false
    }
    
    func setupStackImage() {
        let rows = 2
        let cols = 3
        
        let spasingInStack: CGFloat = 18
        
        bigStackImage.spacing = spasingInStack
        bigStackImage.axis = .vertical
        bigStackImage.distribution = .fillEqually
        
        var indexArrayImage = 0
        
        for _ in 0..<rows {
            
            let smallStack = UIStackView()
            smallStack.spacing = spasingInStack
            smallStack.axis = .horizontal
            smallStack.distribution = .fillEqually

            for _ in 0..<cols {
                
                let imageButton = UIButton()
                imageButton.layer.cornerRadius = 5
                imageButton.layer.masksToBounds = true
                imageButton.setBackgroundImage(arrayImageForPicker[indexArrayImage], for: .normal)
                imageButton.tag = indexArrayImage
                indexArrayImage += 1
                smallStack.addArrangedSubview(imageButton)
                arrayButtonImage.append(imageButton)
            }
            
            bigStackImage.addArrangedSubview(smallStack)
        }
        
        view.addSubview(bigStackImage)
        
        bigStackImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bigStackImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bigStackImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            bigStackImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplierForWidthAnchor),
            bigStackImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplierForHeightAnchor)
        ])
        
        bigStackImage.addArrangedSubview(viewUnderButton)

    }
    
    func redBorderBTouch() {
        arrayButtonImage.forEach { UIButton in
            UIButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        }
    }
    
    @objc func selectImage(_ sender: UIButton) {
        sender.layer.borderWidth = 2
        sender.layer.borderColor = UIColor.white.cgColor
        sender.layer.masksToBounds = true
        sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        let index = sender.tag
        let imageName = strs[index]
        self.callBack?("\(imageName)")
        
        for i in arrayButtonImage {
            if i != sender {
                i.layer.borderWidth = 0
                i.transform = .identity
            }
        }
    }
    
    
}
