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
        let startSlide = SKShapeNode(rectOf: CGSize(width: frame.width / 2, height: 20), cornerRadius: 10)
        startSlide.position = CGPoint(x: frame.midX, y: frame.midY / 2)
        startSlide.fillColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        startSlide.zPosition = 10
        addChild(startSlide)
        
        let label  = SKLabelNode (text: "Slide to start")
        label.fontSize = 22
        let customFont = UIFont(name: "Menlo-Italic", size: 20)!
        label.fontName = customFont.fontName
        label.fontColor = #colorLiteral(red: 0.01476755552, green: 0.9785382152, blue: 1, alpha: 1)
        label.position = CGPoint(x: frame.midX, y: startSlide.position.y + label.fontSize)
        label.zPosition = 10
        addChild(label)
        
        if let handSlideImage = UIImage(systemName: "hand.point.up.left.fill") {
            let texture = SKTexture(image: handSlideImage)
            let handSlide = SKSpriteNode(texture: texture)
            handSlide.size = CGSize(width: 40, height: 40)
            handSlide.position = CGPoint(x: frame.midX, y: startSlide.frame.minY - 5)
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
        
    }
}
