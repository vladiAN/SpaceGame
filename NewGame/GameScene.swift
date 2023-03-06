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
    static let starShip: UInt32 = 2
    static let planet: UInt32 = 4
    static let platform: UInt32 = 8
    static let bullet: UInt32 = 16
}

class GameScene: SKScene {

    var starShip: SKSpriteNode!
    var planet: Planet!
    var bullet: SKSpriteNode!
    var bulletTimerShot: Timer?
    var delayToShot = 0.1
    
    let musicSoundEffects = MusicManager.shared

    override func didMove(to view: SKView) {
        scene?.size = UIScreen.main.bounds.size
        
        physicsWorld.contactDelegate = self
        
        setScene()
        
        //musicSoundEffects.playBackgroundMusic()
        //musicSoundEffects.loadSoundEffects()
    }
    
    func setScene() {
        setBorderBody()
        setBackground()
        
        starShip = StarShip.setStarship(at: CGPoint(x: frame.midX, y: frame.minY + 100))
        addChild(starShip)
        
        //createPlanet()
        setPlatform()
    }
    
    func setBorderBody() {
        let borderBody =  SKPhysicsBody (edgeLoopFrom: frame)
        borderBody.friction =  0
        self.physicsBody = borderBody
        self.physicsBody?.categoryBitMask = BitMasks.borderBody
    }
    
    func setPlatform() {
        let platformImage = SKSpriteNode(imageNamed: "platform")
        platformImage.position = CGPoint(x: frame.midX, y: frame.minY + (platformImage.size.height / 2))
        platformImage.zPosition = -1
        
        let platform = SKShapeNode(rectOf: CGSize(width: frame.width - 10, height: 0))
        platform.position = CGPoint(x: frame.midX, y: starShip.frame.minY)
        platform.physicsBody = SKPhysicsBody(rectangleOf: platform.frame.size)
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.affectedByGravity = false
        platform.physicsBody?.categoryBitMask = BitMasks.platform
        platform.zPosition = -1
        
        addChild(platform)
        addChild(platformImage)
    }
    
    func setBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.size = CGSize(width: self.size.width, height: self.size.height)
        background.zPosition = -100
        addChild(background)
    }
    
    @objc func setBullet() {
        bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.size = CGSize(width: 20, height: 20)
        bullet.position.y = frame.midY - 260
        bullet.position.x = starShip.position.x
        
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width / 2)
        bullet.physicsBody?.categoryBitMask = BitMasks.bullet
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.isDynamic = false

        bullet.zRotation = CGFloat.pi / 4
        bullet.zPosition = -1
        
        addChild(bullet)
        
        musicSoundEffects.soundEffects(fileName: "shot")
        
        let moveUpAction = SKAction.moveBy(x: 0, y: self.frame.height, duration: 1.0)
        let removeBullet = SKAction.removeFromParent()
        let sequense = SKAction.sequence([moveUpAction, removeBullet])
        bullet.run(sequense)
    }
    
    func createPlanet() {
        planet = PlanetFactory.createNewPlanet(frame: frame)
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
        
        guard let bodyNotPlanet = [contact.bodyA, contact.bodyB].first(where: { $0.categoryBitMask != BitMasks.planet}) else { return }
        
        if bodyNotPlanet.categoryBitMask == BitMasks.bullet {
            bodyNotPlanet.node?.removeFromParent()
            planet.lives -= 1
            if planet.lives < 1 {
                planet.replaceWithTwoSmaller()
                if self.children.filter({ $0 is Planet}).count == 2 {
                   createPlanet()
                }
            }
        }
        
        guard let bodyPlanet = [contact.bodyA, contact.bodyB].first(where: { $0.categoryBitMask == BitMasks.planet}) else { return }
        
        if let contactPlanet = bodyPlanet.node as? Planet {
            planet = contactPlanet
        }
        
        if contact.bodyA.categoryBitMask == BitMasks.planet &&
            contact.bodyB.categoryBitMask == BitMasks.borderBody ||
            contact.bodyA.categoryBitMask == BitMasks.borderBody &&
            contact.bodyB.categoryBitMask == BitMasks.planet {
            planet.impulsFromBorder(planetOnTheLeft: planet.position.x < frame.midX)
        }
        
        if contact.bodyA.categoryBitMask == BitMasks.planet &&
            contact.bodyB.categoryBitMask == BitMasks.platform ||
            contact.bodyA.categoryBitMask == BitMasks.platform &&
            contact.bodyB.categoryBitMask == BitMasks.planet {
            musicSoundEffects.soundEffects(fileName: "ballDrop")
        }
    }
}
