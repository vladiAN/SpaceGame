//
//  Extention.swift
//  NewGame
//
//  Created by Алина Андрушок on 20.03.2023.
//

import Foundation
import SpriteKit

extension SKPhysicsContact {
    func hasContact(contact: SKPhysicsContact, categoryA: UInt32, categoryB: UInt32) -> (bodyA: SKPhysicsBody, bodyB: SKPhysicsBody)? {
            let bodyA: SKPhysicsBody = bodyA
            let bodyB: SKPhysicsBody = bodyB
            if (bodyA.categoryBitMask == categoryA && bodyB.categoryBitMask == categoryB) {
                return (bodyA, bodyB)
            }
            if (bodyA.categoryBitMask == categoryB && bodyB.categoryBitMask == categoryA) {
                return (bodyB, bodyA)
            }
            return nil
        }
}
