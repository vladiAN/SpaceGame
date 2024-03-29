//
//  Planet.swift
//  NewGame
//
//  Created by Алина Андрушок on 22.02.2023.
//

import Foundation
import SpriteKit

enum SizePlanet: CGFloat {
    case sizeBig = 100
    case sizeNormal = 80
    case sizeSmall = 64
}

class Planet: SKSpriteNode {

    let vibration = VibrationManager.shared
    
    init(size: CGSize) {
        let randomInt = Int.random(in: 1...11)
        let texture = SKTexture(imageNamed: "planet\(randomInt)")
        super.init(texture: texture, color: .clear, size: size)
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.restitution = 1
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.categoryBitMask = BitMasks.planet
        self.physicsBody?.contactTestBitMask = BitMasks.borderBody | BitMasks.bullet | BitMasks.platform
        self.physicsBody?.collisionBitMask = BitMasks.platform
        
        labelNumber.fontName = "HelveticaNeue-Bold"
        labelNumber.fontSize = 40
        labelNumber.position = CGPoint.zero
        labelNumber.verticalAlignmentMode = .center
        labelNumber.horizontalAlignmentMode = .center
        labelNumber.text = "\(lives)"
        labelNumber.zPosition = 10
        
        self.addChild(labelNumber)
    }
    
    let labelNumber = SKLabelNode(text: "")

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var lives = 5 {
        didSet {
            labelNumber.text = "\(lives)"
        }
    }
    
    func replaceWithTwoSmaller() {
      
        let planetDecayFactor: CGFloat = 0.8
        
        let sizeCildPlanet = CGSize(width: self.size.width * planetDecayFactor, height: self.size.width * planetDecayFactor)
        
        if sizeCildPlanet.width >= SizePlanet.sizeSmall.rawValue {
            let childPlanetLeft = Planet(size: sizeCildPlanet)
            let childPlanetRight = Planet(size: sizeCildPlanet)
            
            setChildPlanet(childPlanet: childPlanetLeft, childPlanetLeft: true)
            setChildPlanet(childPlanet: childPlanetRight, childPlanetLeft: false)
            
            MusicManager.shared.soundEffects(fileName: "ballSeparation")
            parent?.addChild(childPlanetLeft)
            parent?.addChild(childPlanetRight)
            removeFromParent()
            vibration.destroyedPlanet()
        } else {
            MusicManager.shared.soundEffects(fileName: "ballSeparation")
            removeFromParent()
            vibration.destroyedPlanet()
        }
        
    }
    
    func setChildPlanet(childPlanet: Planet, childPlanetLeft: Bool) {
        
        childPlanet.position = position
        
        if childPlanet.size.width == SizePlanet.sizeNormal.rawValue {
            childPlanet.lives = 25
        } else if childPlanet.size.width == SizePlanet.sizeSmall.rawValue {
            childPlanet.lives = 10
        }
        
        let impulseVector = childPlanetLeft ? CGVector(dx: -40, dy: 40) : CGVector(dx: 40, dy: 40)
        let setPhysicsBody = SKAction.run {
            childPlanet.physicsBody = SKPhysicsBody(circleOfRadius: childPlanet.size.height / 2)
            childPlanet.physicsBody?.restitution = 1
            childPlanet.physicsBody?.linearDamping = 0
            childPlanet.physicsBody?.affectedByGravity = true
            childPlanet.physicsBody?.isDynamic = true
            childPlanet.physicsBody?.applyImpulse(impulseVector)
            childPlanet.physicsBody?.categoryBitMask = BitMasks.planet
            childPlanet.physicsBody?.contactTestBitMask = BitMasks.borderBody | BitMasks.platform | BitMasks.bullet
            childPlanet.physicsBody?.collisionBitMask = BitMasks.borderBody | BitMasks.platform
        }
        childPlanet.run(setPhysicsBody)
    }
    
    func impulsFromBorder(planetOnTheLeft: Bool) {
        
        let forceOfPush: Int
        
        switch self.size.width {
        case SizePlanet.sizeBig.rawValue:
            forceOfPush = 30
        case SizePlanet.sizeNormal.rawValue:
            forceOfPush = 20
        case SizePlanet.sizeSmall.rawValue:
            forceOfPush = 10
        default:
            return
        }
        
        planetOnTheLeft ?
        self.physicsBody?.applyImpulse(CGVector(dx: forceOfPush, dy: 0)) :
        self.physicsBody?.applyImpulse(CGVector(dx: -forceOfPush, dy: 0))
    }
    
}

class PlanetFactory: SKSpriteNode {
    
    static func createNewPlanet(frame: CGRect) -> Planet {
        
        let randomSizeArr = [SizePlanet.sizeBig, SizePlanet.sizeNormal, SizePlanet.sizeSmall]
        
        let randomSizePlanet = randomSizeArr.randomElement()!
        

        let randomPlanet = Planet(size: CGSize(width: randomSizePlanet.rawValue, height: randomSizePlanet.rawValue))
        
        switch randomSizePlanet {
        case .sizeBig:
            randomPlanet.lives = 50
        case .sizeNormal:
            randomPlanet.lives = 40
        case .sizeSmall:
            randomPlanet.lives = 30
        }
        
        let randomBool = Bool.random()
        let moveDuration = 2.0
        let halfPlanetWidth = randomPlanet.size.width / 2
        let yPosition = frame.maxY - CGFloat(Int.random(in: 200...250))
        let xPosition = randomBool ? frame.minX - halfPlanetWidth: frame.maxX + halfPlanetWidth
        let impulseVector = randomBool ? CGVector(dx: 30, dy: 0) : CGVector(dx: -30, dy: 0)
        
        randomPlanet.position = CGPoint(x: xPosition, y: yPosition)
        
        let moveFromBorderAction = randomBool ?
        SKAction.move(to: CGPoint(x: frame.minX + halfPlanetWidth, y: yPosition), duration: moveDuration) :
        SKAction.move(to: CGPoint(x: frame.maxX - halfPlanetWidth, y: yPosition), duration: moveDuration)
        
        let setPhysicsBody = SKAction.run {
            randomPlanet.physicsBody?.applyImpulse(impulseVector)
            randomPlanet.physicsBody?.affectedByGravity = true
            randomPlanet.physicsBody?.collisionBitMask = BitMasks.borderBody | BitMasks.platform
        }
        
        let rotateAction = randomBool ?
        SKAction.rotate(byAngle: -CGFloat.pi, duration: 10) :
        SKAction.rotate(byAngle: CGFloat.pi, duration: 10)
        let repeatRotate = SKAction.repeatForever(rotateAction)

        let sequence = SKAction.sequence([moveFromBorderAction, setPhysicsBody, repeatRotate])
        randomPlanet.run(sequence)
        
        return randomPlanet
    }
    

}
