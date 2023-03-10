//
//  StarShip.swift
//  NewGame
//
//  Created by Алина Андрушок on 22.02.2023.
//

import Foundation
import SpriteKit

class StarShip {
    static func setStarship(at point: CGPoint) -> SKSpriteNode {
        let starShipWidth: CGFloat = 60
        let starShipHeight: CGFloat = 70
        let starShipImage = UIImage(named: "ship1")
        let starShipTexture = SKTexture(image: starShipImage!)
        let starShip = SKSpriteNode(texture: starShipTexture)
        let starshipSize = CGSize(width: starShipWidth, height: starShipHeight)
        starShip.size = CGSize(width: starshipSize.width, height: starshipSize.height)
        starShip.position = point
        starShip.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: starShipWidth, height: starShipHeight))
        starShip.physicsBody?.isDynamic = false
        starShip.physicsBody?.categoryBitMask = BitMasks.starShip
        return starShip
    }
}


