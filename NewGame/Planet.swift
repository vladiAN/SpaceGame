//
//  Planet.swift
//  NewGame
//
//  Created by Алина Андрушок on 22.02.2023.
//

import Foundation
import SpriteKit

class Planet: SKSpriteNode {
    
    static func createPlanet(frame: CGRect) -> SKSpriteNode {
        
        let arrayOfPlanets = Array(1...11).map { int in
            SKSpriteNode(imageNamed: "planet\(int)")
        }
        
        let randomInt = Int.random(in: 0...10)
        let randomPlanet = arrayOfPlanets[randomInt]
        
        randomPlanet.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        randomPlanet.physicsBody?.affectedByGravity = false
        randomPlanet.physicsBody?.isDynamic = false
        randomPlanet.physicsBody?.restitution = 1
        randomPlanet.physicsBody?.linearDamping = 0
        randomPlanet.physicsBody?.categoryBitMask = BitMasks.planet
        randomPlanet.physicsBody?.contactTestBitMask = BitMasks.borderBody
        randomPlanet.physicsBody?.collisionBitMask = 1
        
        let randomBool = Bool.random()
        let moveDuration = 2.0
        let halfPlanetWidth = randomPlanet.size.width / 2
        let yPosition = frame.maxY - CGFloat(Int.random(in: 150...200))
        let xPosition = randomBool ? frame.minX : frame.maxX
        let impulseVector = randomBool ? CGVector(dx: 30, dy: 0) : CGVector(dx: -30, dy: 0)
        
        randomPlanet.position = CGPoint(x: xPosition, y: yPosition)
        
        let moveAction = randomBool ?
        SKAction.move(to: CGPoint(x: frame.minX + halfPlanetWidth, y: yPosition), duration: moveDuration) :
        SKAction.move(to: CGPoint(x: frame.maxX - halfPlanetWidth, y: yPosition), duration: moveDuration)
        
        let rotateAction = randomBool ?
        SKAction.rotate(byAngle: -CGFloat.pi, duration: 10) :
        SKAction.rotate(byAngle: CGFloat.pi, duration: 10)
        let repeatRotate = SKAction.repeatForever(rotateAction)
        
        let setPhysicsBody = SKAction.run {
            randomPlanet.physicsBody?.isDynamic = true
            randomPlanet.physicsBody?.affectedByGravity = true
            randomPlanet.physicsBody?.applyImpulse(impulseVector)
        }

        let sequence = SKAction.sequence([moveAction, setPhysicsBody, repeatRotate])
        randomPlanet.run(sequence)
        
        return randomPlanet
    }
    
    static func setLabelOnPlanet() -> SKLabelNode {
        let labelNumber = SKLabelNode(text: "")
        labelNumber.fontName = "HelveticaNeue-Bold"
        labelNumber.fontSize = 40
        labelNumber.position = CGPoint.zero
        labelNumber.verticalAlignmentMode = .center
        labelNumber.horizontalAlignmentMode = .center
        return labelNumber
    }
    
}
