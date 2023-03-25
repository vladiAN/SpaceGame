//
//  Bonus.swift
//  NewGame
//
//  Created by Алина Андрушок on 22.03.2023.
//

import Foundation
import SpriteKit

enum BonusName: String {
    
    case bang, ghost, freezing
    
    var name: String {
        switch self {
        case .bang: return "explosion"
        case .ghost: return "ghost"
        case .freezing: return "3bullet"
        }
    }
}

class Bonus {
    
    static func setBonus() -> SKSpriteNode {
        let allBonus = [
            BonusName.bang.name,
            BonusName.ghost.name,
            BonusName.freezing.name
        ]
        let randomBonus = Int.random(in: 0..<allBonus.count)
        let bonusName = allBonus[randomBonus]
        
        let bonusWidth: CGFloat = 30
        var bonusTexture = SKTexture()
        
        if let bonusImage = UIImage(named: bonusName) {
            bonusTexture = SKTexture(image: bonusImage)
        }
        
        let bonus = SKSpriteNode(texture: bonusTexture)
        bonus.name = bonusName
        bonus.size = CGSize(width: bonusWidth, height: bonusWidth)
        bonus.physicsBody = SKPhysicsBody(circleOfRadius: bonusWidth / 2)
        bonus.physicsBody?.isDynamic = true
        bonus.physicsBody?.affectedByGravity = true
        bonus.physicsBody?.categoryBitMask = BitMasks.bonus
        bonus.physicsBody?.collisionBitMask = BitMasks.platform
        return bonus
    }
    
}
