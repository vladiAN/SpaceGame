//
//  BackGroundImageVC.swift
//  NewGame
//
//  Created by Алина Андрушок on 08.03.2023.
//

import UIKit

class ImagePickerVC: UIViewController {

    
    let closeButton = ButtonFactory.createButton(imageName: "xmark.circle")
    
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
        let cols = 3
        
        bigStackImage.spacing = 8
        bigStackImage.axis = .vertical
        bigStackImage.distribution = .fillEqually
        
        var indexArrayImage = 0
        
        for _ in 0..<rows {
            
            let smallStack = UIStackView()
            smallStack.spacing = 8
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
            bigStackImage.topAnchor.constraint(equalTo: closeButton.bottomAnchor),
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
        sender.layer.borderWidth = 5
        sender.layer.borderColor = UIColor.white.cgColor
        
        let index = sender.tag
        let imageName = strs[index]
        self.callBack?("\(imageName)")
        
        for i in arrayButtonImage {
            if i != sender {
                i.layer.borderWidth = 0
            }
        }
    }
    
    
}
