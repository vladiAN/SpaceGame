//
//  StarShip.swift
//  NewGame
//
//  Created by Алина Андрушок on 22.02.2023.
//

import Foundation
import SpriteKit

class StarShip: SKSpriteNode {
    static func setStarship(at point: CGPoint) -> SKSpriteNode {
        let starShipTexture = SKTexture(imageNamed: "ship")
        let starShip = SKSpriteNode(texture: starShipTexture)
        let starshipSize = CGSize(width: 100, height: 100)
        starShip.size = CGSize(width: starshipSize.width, height: starshipSize.height)
        starShip.position = point
       // starShip.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 100))
        starShip.physicsBody?.isDynamic = false
        return starShip
    }
}


