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
    static let bonus: UInt32 = 32
}

class GameScene: SKScene {
    
    var startSlide: StartSlide?
    
    var starShip: SKSpriteNode!
    var bulletTimerShot: Timer?
    var delayToShot = 0.1
    let platformImage = SKSpriteNode(imageNamed: "platform")
    var scoreCallBack: ((Int) -> ())?
    var restartCallBack: (() -> ())?
    var score = 0 {
        didSet {
            scoreCallBack!(score)
        }
    }
    var isNewRecord = false
    var isBonusShot = false
    var isStartGame = false
    
    var deltaXPosition: CGFloat = 0

    let musicSoundEffects = MusicManager.shared
    
    override func didMove(to view: SKView) {
        
        scene?.size = view.frame.size
        
        physicsWorld.contactDelegate = self
        
        setScene()
    }
    
    func setScene() {
        setBorderBody()
        createStarShip(imageName: nil)
        //createPlanet()
        setPlatform()
        setStartSlide()
        
    }
    
    
    
    func createStarShip(imageName: String?) {
        if let imageName {
            starShip = StarShip.setStarship(at: CGPoint(x: frame.midX, y: frame.minY + 100), imageName: imageName)
        } else {
            starShip = StarShip.setStarship(at: CGPoint(x: frame.midX, y: frame.minY + 100), imageName: UserDefaults.standard.string(forKey: "skinShip")!)
        }
        
        addChild(starShip)
    }
    
    func createBonus(position: CGPoint) {
        let bonus = Bonus.setBonus()
        bonus.position = position
        addChild(bonus)
    }
    
    func chanceToBonus(probability: Int) -> Bool {
        let randomInt = Int.random(in: 0...100)
        return randomInt <= probability
    }
    
    func setBoundariesForStarShip() {
        let starShipHalfWidth = starShip.frame.width / 2
        let starShipMaxX = size.width - starShipHalfWidth
        let starShipMinX = starShipHalfWidth
        
        if starShip.position.x > starShipMaxX {
            starShip.position.x = starShipMaxX
        } else if starShip.position.x < starShipMinX {
            starShip.position.x = starShipMinX
        }
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
    
    func createBullet(deviation: CGFloat) {
        let bullet = Bullet(starShip: starShip)
        addChild(bullet)
        bullet.setShot(bullet: bullet, deviation: deviation, bulletAltitude: self.frame.height)
    }
    
    
    func setShot() {
        if isBonusShot {
            self.createBullet(deviation: 0)
            self.createBullet(deviation: -100)
            self.createBullet(deviation: 100)
        } else {
            self.createBullet(deviation: 0)
        }
    }
    
    func shooting() {
        let shooting = SKAction.repeatForever(.sequence([
            .wait(forDuration: delayToShot),
            .run {
                self.setShot()
            }
        ]))
        self.run(shooting, withKey: "shooting")
    }

    func ghostBonus() {
        starShip.alpha = 0.5
        starShip.physicsBody?.contactTestBitMask = BitMasks.bonus
        let backToNormal = SKAction.sequence([
            .wait(forDuration: 5),
            .run { [weak self] in
                self!.starShip.alpha = 1
                self!.starShip.physicsBody?.contactTestBitMask = BitMasks.bonus | BitMasks.planet
            }
        ])
        self.run(backToNormal)
    }
   
    func setStartSlide() {
        startSlide = StartSlide(frame: frame)
        if let startSlide = startSlide {
            addChild(startSlide)
        }
        
    }
    
    func gameOver() {
        let bestScore = UserDefaults.standard.integer(forKey: "bestScore")
        if score > bestScore {
            UserDefaults.standard.set(score, forKey: "bestScore")
            isNewRecord = true
        }
        let gameOver = GameOver(size: self.size, isNewRecord: isNewRecord) { [weak self] in
            self?.removeAllChildren()
            self?.score = 0
            self?.restartCallBack!()
            self?.isStartGame = false
        }
        gameOver.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(gameOver)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            switch deltaXPosition {
            case let delta where delta > 0:
                starShip.position.x = touchLocation.x - deltaXPosition
            case let delta where delta < 0:
                starShip.position.x = touchLocation.x + abs(deltaXPosition)
            default:
                starShip.position.x = touchLocation.x
            }
            setBoundariesForStarShip()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startSlide?.removeFromParent()
        if isStartGame == false {
            createPlanet()
            isStartGame = true
        }
        guard let touch = touches.first else { return }
        deltaXPosition = touch.location(in: self).x - starShip.position.x
        shooting()
        musicSoundEffects.shotEffects()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeAction(forKey: "shooting")
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
                if chanceToBonus(probability: 30) { //шанс на випадання бонусу
                    createBonus(position: planet.position)
                }
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
        
        if let contactPlanetWithPlatform = contact.hasContact(contact: contact, categoryA: BitMasks.planet, categoryB: BitMasks.platform) {
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
        
        if contact.hasContact(contact: contact, categoryA: BitMasks.planet, categoryB: BitMasks.starShip) != nil {
            musicSoundEffects.soundEffects(fileName: "ballSeparation")
            musicSoundEffects.stopBackgroundMusic()
            musicSoundEffects.soundEffects(fileName: "game_over")
            createExplosion(position: starShip.position)
            starShip.removeFromParent()
            self.removeAction(forKey: "shooting")
            gameOver()
        }
        
        if let contactStarShipWithBonus = contact.hasContact(contact: contact, categoryA: BitMasks.starShip, categoryB: BitMasks.bonus) {
            
            if let bonusName = contactStarShipWithBonus.bodyB.node?.name as? String {
                switch bonusName {
                case "ghost":
                    musicSoundEffects.soundEffects(fileName: "ghostBonus")
                    ghostBonus()
                    guard contactStarShipWithBonus.bodyB.node?.removeFromParent() != nil else { return }
                case "explosion":
                    musicSoundEffects.soundEffects(fileName: "explosion")
                    let planetInSceneArray = self.children.filter({ $0 is Planet})
                    for i in planetInSceneArray {
                        if let planet = i as? Planet {
                            score += planet.lives
                        }
                        createExplosion(position: i.position)
                        i.removeFromParent()
                    }
                    createPlanet()
                    guard contactStarShipWithBonus.bodyB.node?.removeFromParent() != nil else { return }
                case "3bullet":
                    isBonusShot = true
                    self.run(SKAction.sequence([
                        .wait(forDuration: 5),
                        .run {
                            self.isBonusShot = false
                        }
                    ]))
                    guard contactStarShipWithBonus.bodyB.node?.removeFromParent() != nil else { return }
                default:
                    return
                }
            }
        }
    }
}
