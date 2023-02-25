//
//  Planet.swift
//  NewGame
//
//  Created by Алина Андрушок on 22.02.2023.
//

import Foundation
import SpriteKit

class Planet: SKSpriteNode {
    
    init() {
        let randomInt = Int.random(in: 1...11)
        let texture = SKTexture(imageNamed: "planet\(randomInt)")
        let size = CGSize(width: 100, height: 100)
        super.init(texture: texture, color: .clear, size: size)
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.restitution = 1
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.categoryBitMask = BitMasks.planet
        self.physicsBody?.contactTestBitMask = BitMasks.borderBody
        self.physicsBody?.collisionBitMask = 1
        
        labelNumber.fontName = "HelveticaNeue-Bold"
        labelNumber.fontSize = 40
        labelNumber.position = CGPoint.zero
        labelNumber.verticalAlignmentMode = .center
        labelNumber.horizontalAlignmentMode = .center
        labelNumber.text = "20"
        labelNumber.zPosition = 10
        
        self.addChild(labelNumber)
    }
    
    let labelNumber = SKLabelNode(text: "")

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var lives = 20 {
        didSet {
            labelNumber.text = "\(lives)"
        }
    }

}

class PlanetFactory: SKSpriteNode {
    
    static func createPlanet(frame: CGRect) -> Planet {

        let randomPlanet = Planet()
        
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
}
