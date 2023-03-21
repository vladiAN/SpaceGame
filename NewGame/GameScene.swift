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
    var bullet: SKSpriteNode!
    var bulletTimerShot: Timer?
    var delayToShot = 0.1
    let platformImage = SKSpriteNode(imageNamed: "platform")
    var scoreCallBack: ((Int) -> ())?
    var score = 0 {
        didSet {
            scoreCallBack!(score)
        }
    }
    
    let musicSoundEffects = MusicManager.shared
    
    override func didMove(to view: SKView) {
        scene?.size = view.frame.size
                
        physicsWorld.contactDelegate = self
        
        setScene()
    }
    
    func setScene() {
        setBorderBody()
        createStarShip(imageName: nil)
        createPlanet()
        setPlatform()
    }
    
    func createStarShip(imageName: String?) {
        if let imageName {
            starShip = StarShip.setStarship(at: CGPoint(x: frame.midX, y: frame.minY + 100), imageName: imageName)
        } else {
            starShip = StarShip.setStarship(at: CGPoint(x: frame.midX, y: frame.minY + 100), imageName: UserDefaults.standard.string(forKey: "skinShip")!)
        }
        addChild(starShip)
    }
    
    func setBorderBody() {
        let borderBody =  SKPhysicsBody (edgeLoopFrom: frame)
        borderBody.friction =  0
        self.physicsBody = borderBody
        self.physicsBody?.categoryBitMask = BitMasks.borderBody
    }
    
    func setPlatform() {
        platformImage.position = CGPoint(x: frame.midX, y: frame.minY + (platformImage.size.height / 2))
        platformImage.zPosition = -1
        
        let platform = SKShapeNode(rectOf: CGSize(width: frame.width - 10, height: 0))
        platform.position = CGPoint(x: frame.midX, y: starShip.frame.minY)
        platform.physicsBody = SKPhysicsBody(rectangleOf: platform.frame.size)
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.affectedByGravity = false
        platform.physicsBody?.categoryBitMask = BitMasks.platform
        platform.zPosition = -2
        
        addChild(platform)
        addChild(platformImage)
    }

    @objc func setBullet() {
        bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.size = CGSize(width: 20, height: 20)
        bullet.position.y = starShip.frame.maxY
        bullet.position.x = starShip.position.x
        
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width / 2)
        bullet.physicsBody?.categoryBitMask = BitMasks.bullet
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
        let planet = PlanetFactory.createNewPlanet(frame: frame)
        addChild(planet)
        
    }
    
    func createExplosion(position: CGPoint) {
        let explosion = SKEmitterNode(fileNamed: "Explosion.sks")!
        let removeExplosion = SKAction.sequence([
            .wait(forDuration: 2),
            .removeFromParent()
        ])
        explosion.position = position
        explosion.zPosition = 15
        explosion.run(removeExplosion)
        addChild(explosion)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            starShip.position.x = touchLocation.x
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setBullet()
        let action = SKAction.repeatForever(.sequence([
            .wait(forDuration: delayToShot),
            .run {
                self.setBullet()
            }
        ]))
        self.run(action, withKey: "bullet")
        musicSoundEffects.shotEffects()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeAction(forKey: "bullet")
        musicSoundEffects.shotEffectsStop()
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if let contactPlanetWithBullet = contact.hasContact(contact: contact, categoryA: BitMasks.planet, categoryB: BitMasks.bullet) {
            contactPlanetWithBullet.bodyB.node?.removeFromParent()
            guard let planet = contactPlanetWithBullet.bodyA.node as? Planet else { return }
            planet.lives -= 1
            score += 1
            scoreCallBack?(score)
            if planet.lives < 1 {
                createExplosion(position: planet.position)
                planet.replaceWithTwoSmaller()
                let planetInSceneArray = self.children.filter({ $0 is Planet})
                print(planetInSceneArray.count)
                switch planetInSceneArray.count {
                case 0...1:
                    createPlanet()
                case 2..<3:
                    if planetInSceneArray[0].frame.width < 80 && planetInSceneArray[1].frame.width < 80 {
                        createPlanet()
                    }
                default: return

                }
            }
        }

        if let contactPlanetWithBorder = contact.hasContact(contact: contact, categoryA: BitMasks.planet, categoryB: BitMasks.borderBody) {
            if let planet = contactPlanetWithBorder.bodyA.node as? Planet {
                planet.impulsFromBorder(planetOnTheLeft: planet.position.x < frame.midX)
            }
        }

        if let contactPlanetWithPlatform =  contact.hasContact(contact: contact, categoryA: BitMasks.planet, categoryB: BitMasks.platform) {
            musicSoundEffects.soundEffects(fileName: "ballDrop")
            if let planet = contactPlanetWithPlatform.bodyA.node as? Planet {
                switch planet.size.width {
                case SizePlanet.sizeBig.rawValue:
                    planet.physicsBody?.velocity.dy = 1300
                case SizePlanet.sizeNormal.rawValue:
                    planet.physicsBody?.velocity.dy = 1200
                case SizePlanet.sizeSmall.rawValue:
                    planet.physicsBody?.velocity.dy = 1000
                default:
                    return
                }
            }
        }
        
    }
}

