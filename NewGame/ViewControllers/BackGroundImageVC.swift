//
//  BackGroundImageVC.swift
//  NewGame
//
//  Created by Алина Андрушок on 08.03.2023.
//

import UIKit

class BackGroundImageVC: UIViewController {
    
    let closeButton = ButtonFactory.createButton(imageName: "xmark.circle")
    
    var arrayImageForBackground: [UIImage] {
        get {
            return [
                UIImage(named: "background1")!,
                UIImage(named: "background2")!,
                UIImage(named: "background3")!,
                UIImage(named: "background4")!,
                UIImage(named: "background5")!,
                UIImage(named: "background6")!
            ]
        }
    }
    
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
        
        view.backgroundColor = .brown
        
        settingsCloseButton()
        setupStackImage()
        redBorderBTouch()
    }
    
    func settingsCloseButton() {
        closeButton.addTarget(self, action: #selector(closeWindow), for: .touchUpInside)
        
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40)
            ])
    }
    
    @objc func closeWindow() {
        self.dismiss(animated: true)
    }
    
    func setupStackImage() {
        let rows = 3
        let cols = 2
        
        bigStackImage.spacing = 8
        bigStackImage.axis = .vertical
        bigStackImage.distribution = .fillEqually
        
        var indexArrayImageForBackground = 0
        
        for _ in 0..<rows {
            
            let smallStack = UIStackView()
            smallStack.spacing = 8
            smallStack.axis = .horizontal
            smallStack.distribution = .fillEqually

            for _ in 0..<cols {
                
                let imageBackground = UIButton()
                imageBackground.layer.cornerRadius = 5
                imageBackground.layer.masksToBounds = true
                imageBackground.layer.shadowColor = imageBackground.backgroundColor?.cgColor
                imageBackground.layer.shadowOffset = CGSize(width: 2, height: 5)
                imageBackground.layer.shadowOpacity = 0.5
                imageBackground.layer.shadowRadius = 2
                imageBackground.setBackgroundImage(arrayImageForBackground[indexArrayImageForBackground], for: .normal)
                indexArrayImageForBackground += 1
                smallStack.addArrangedSubview(imageBackground)
                arrayButtonImage.append(imageBackground)
            }
            
            bigStackImage.addArrangedSubview(smallStack)
        }
        
        view.addSubview(bigStackImage)
        
        bigStackImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bigStackImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bigStackImage.topAnchor.constraint(equalTo: closeButton.bottomAnchor),
            bigStackImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            bigStackImage.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        bigStackImage.addArrangedSubview(viewUnderButton)

    }
    
    func redBorderBTouch() {
        for i in 0...arrayButtonImage.count - 1 {
            arrayButtonImage[i].addTarget(self, action: #selector(selectImage), for: .touchUpInside)
            
            }
    }
    
    @objc func selectImage(_ sender: UIButton) {
        sender.layer.borderWidth = 5
        sender.layer.borderColor = UIColor.red.cgColor
        
        for i in arrayButtonImage {
            if i == sender {
                let indexImage = arrayButtonImage.firstIndex(of: i)
                
                switch indexImage {
                case 0: UserDefaultManager.shared.defaults.set("background1", forKey: "imageBackground")
                case 1: UserDefaultManager.shared.defaults.set("background2", forKey: "imageBackground")
                case 2: UserDefaultManager.shared.defaults.set("background3", forKey: "imageBackground")
                case 3: UserDefaultManager.shared.defaults.set("background4", forKey: "imageBackground")
                case 4: UserDefaultManager.shared.defaults.set("background5", forKey: "imageBackground")
                case 5: UserDefaultManager.shared.defaults.set("background6", forKey: "imageBackground")
                default: print("error background")
                }
            } else {
                i.layer.borderWidth = 0
            }
        }
    }
}
