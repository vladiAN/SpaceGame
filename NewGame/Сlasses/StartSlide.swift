//
//  StartSlide.swift
//  NewGame
//
//  Created by Алина Андрушок on 27.03.2023.
//

import SpriteKit

class StartSlide: SKNode {
    
    init(frame: CGRect) {
        super.init()
        self.startSlide(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startSlide(frame: CGRect) {
        
        let label  = SKLabelNode (text: "Slide to start")
        let customFont = UIFont(name: "Menlo-Italic", size: 20)!
        label.fontName = customFont.fontName
        label.fontColor = #colorLiteral(red: 0.01476755552, green: 0.9785382152, blue: 1, alpha: 1)
        label.position = CGPoint(x: frame.midX, y: frame.midY / 2)
        label.zPosition = 10
        addChild(label)
        
        let texture = getTexture(systemName: "hand.point.up.left.fill")
        let handSlide = SKSpriteNode(texture: texture)
        handSlide.position = CGPoint(x: frame.midX, y: label.frame.minY - 25)
        handSlide.zPosition = 11
        
        let action = SKAction.sequence([
            SKAction.wait(forDuration: 0),
            .moveBy(x: -50, y: 0, duration: 1),
            .moveBy(x: 100, y: 0, duration: 2),
            .moveBy(x: -50, y: 0, duration: 1)
        ])
        handSlide.run(.repeatForever(action))
        addChild(handSlide)
        
    }
    
    func getTexture(systemName: String) -> SKTexture {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .regular, scale: .default)
        let color = UIColor.white
        let image = UIImage(systemName: systemName, withConfiguration: largeConfig)!.withTintColor(color)
        let data = image.pngData()
        let newImage = UIImage(data: data!)!
        return SKTexture(image: newImage)
    }
}
