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
                UIImage(named: "background")!,
                UIImage(named: "background1")!,
                UIImage(named: "background2")!,
                UIImage(named: "background3")!
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
        let rows = 2
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
        
        bigStackImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bigStackImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        bigStackImage.widthAnchor.constraint(equalToConstant: 300).isActive = true
        bigStackImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8).isActive = true
        
        bigStackImage.addArrangedSubview(viewUnderButton)
        
       
    }
    
    @objc func buttonActionSelect(sender: UIButton!) {
        for i in arrayButtonImage {
            if i.layer.borderWidth == 5 {
                let indexImage = arrayButtonImage.firstIndex(of: i)
                let imageFromArray = arrayImageForBackground[indexImage!]
                imageView.image = imageFromArray
                
                switch indexImage {
                case 0: UserDefaults.standard.set("1", forKey: "imageBackground")
                case 1: UserDefaults.standard.set("2", forKey: "imageBackground")
                case 2: UserDefaults.standard.set("3", forKey: "imageBackground")
                case 3: UserDefaults.standard.set("4", forKey: "imageBackground")
                default: print("error background")
                }
            }
        }
    }
    
    func redBorderBTouch() {
        for i in 0...arrayButtonImage.count - 1 {
            arrayButtonImage[i].addTarget(self, action: #selector(redBorder), for: .touchUpInside)
            }
    }
    
    @objc func redBorder(_ sender: UIButton) {
        sender.layer.borderWidth = 5
        sender.layer.borderColor = UIColor.red.cgColor
        for i in arrayButtonImage {
            if i != sender {
                i.layer.borderWidth = 0
            }
        }
    }
}
