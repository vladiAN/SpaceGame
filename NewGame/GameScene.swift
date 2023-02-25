//
//  GameScene.swift
//  NewGame
//
//  Created by Алина Андрушок on 21.02.2023.
//

import SpriteKit
import GameplayKit

struct BitMasks {
    static let borderBody: UInt32 = 1
    static let spaseShip: UInt32 = 2
    static let planet: UInt32 = 4
    static let platform: UInt32 = 8
    static let bullet: UInt32 = 16
}

class GameScene: SKScene {

    var starShip: SKSpriteNode!
    var planet: Planet!
    
    var bulletTimerShot: Timer?
    var delayToShot = 0.5

    override func didMove(to view: SKView) {
        scene?.size = UIScreen.main.bounds.size
        
        physicsWorld.contactDelegate = self
        
        setScene()
    }
    
    func setScene() {
        setBorderBody()
        setBackground()
        
        starShip = StarShip.setStarship(at: CGPoint(x: frame.midX, y: frame.minY + 100))
        addChild(starShip)
        
        createPlanet()
        setPlatform()
    }
    
    func setBorderBody() {
        let borderBody =  SKPhysicsBody (edgeLoopFrom: frame)
        borderBody.friction =  0
        self.physicsBody = borderBody
        self.physicsBody?.categoryBitMask = BitMasks.borderBody
        self.physicsBody?.contactTestBitMask = BitMasks.planet
    }
    
    func setPlatform() {
        let platform = SKSpriteNode(imageNamed: "platform")
        platform.position = CGPoint(x: frame.midX, y: frame.minY + (platform.size.height / 2))
        platform.zPosition = -1
        
        let groundBorder = SKShapeNode(rectOf: CGSize(width: frame.width, height: 0))
        groundBorder.position = CGPoint(x: frame.midX, y: starShip.frame.minY)
        groundBorder.physicsBody = SKPhysicsBody(rectangleOf: groundBorder.frame.size)
        groundBorder.physicsBody?.isDynamic = false
        
        addChild(groundBorder)
        addChild(platform)
    }
    
    func setBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.size = CGSize(width: self.size.width, height: self.size.height)
        background.zPosition = -100
        addChild(background)
        
    }
    
    @objc func setBullet() {
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.size = CGSize(width: 20, height: 20)
        bullet.position.y = frame.midY - 260
        bullet.position.x = starShip.position.x
        
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width / 2)
        bullet.physicsBody?.categoryBitMask = BitMasks.bullet
        bullet.physicsBody?.contactTestBitMask = BitMasks.planet
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.isDynamic = false

        bullet.zRotation = CGFloat.pi / 4
        bullet.zPosition = -1
        
        addChild(bullet)
        
        let moveUpAction = SKAction.moveBy(x: 0, y: self.frame.height, duration: 1.0)
        let removeBullet = SKAction.removeFromParent()
        let sequense = SKAction.sequence([moveUpAction, removeBullet])
        bullet.run(sequense)
    }
    
    func createPlanet() {
        planet = PlanetFactory.createPlanet(frame: frame)

        addChild(planet)
        
    }
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            
            starShip.position.x = touchLocation.x
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setBullet()
        bulletTimerShot = Timer.scheduledTimer(timeInterval: TimeInterval(delayToShot),
                                           target: self,
                                           selector: #selector(setBullet),
                                           userInfo: nil,
                                           repeats: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        bulletTimerShot?.invalidate()
        bulletTimerShot = nil
    }

    
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        //contact planet with borderBody
        if contact.bodyA.categoryBitMask == BitMasks.planet &&
            contact.bodyB.categoryBitMask == BitMasks.borderBody ||
            contact.bodyA.categoryBitMask == BitMasks.borderBody &&
            contact.bodyB.categoryBitMask == BitMasks.planet {
            planet.position.x < frame.midX ?
            planet.physicsBody?.applyImpulse(CGVector(dx: 30, dy: 0)) :
            planet.physicsBody?.applyImpulse(CGVector(dx: -30, dy: 0))
        }
        
        //contact bullet with planet
        if contact.bodyA.categoryBitMask == BitMasks.planet &&
            contact.bodyB.categoryBitMask == BitMasks.bullet ||
            contact.bodyA.categoryBitMask == BitMasks.bullet &&
            contact.bodyB.categoryBitMask == BitMasks.planet {
            
            planet.lives -= 1
        }
    }
}
