//
//  Bullet.swift
//  NewGame
//
//  Created by Алина Андрушок on 23.03.2023.
//

import Foundation
import SpriteKit

class Bullet: SKSpriteNode {
    
    init(starShip: SKSpriteNode) {
        let texture = SKTexture(imageNamed: "bullet")
        let size = CGSize(width: 20, height: 20)
        
        super.init(texture: texture, color: .clear, size: size)
        
        self.position.y = starShip.frame.maxY
        self.position.x = starShip.position.x
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        self.physicsBody?.categoryBitMask = BitMasks.bullet
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        
        self.zRotation = CGFloat.pi / 4
        self.zPosition = -1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setShot(bullet: Bullet, deviation: CGFloat, bulletAltitude: CGFloat) {
                
        let moveUpAction = SKAction.moveBy(x: deviation, y: bulletAltitude, duration: 1.0)
        let removeBullet = SKAction.removeFromParent()
        let sequense = SKAction.sequence([moveUpAction, removeBullet])
        bullet.run(sequense)
    }
    
}
