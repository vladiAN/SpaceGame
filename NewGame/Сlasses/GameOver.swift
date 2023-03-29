//
//  GameOver.swift
//  NewGame
//
//  Created by Алина Андрушок on 22.03.2023.
//

import SpriteKit

class GameOver: SKNode {
    
    let restartCallBack: () -> ()
    
    init(size: CGSize, isNewRecord: Bool, restartCallBack: @escaping () -> ()) {
        self.restartCallBack = restartCallBack
        super.init()
        self.zPosition = 20
        self.isUserInteractionEnabled = true
        gameOverNode(size: size)
        addNewRecord(size: size, isNewRecord: isNewRecord)
        addBestScoreLabel(size: size)
        addRestartLabel(size: size)
    }
    
    func gameOverNode(size: CGSize) {
        let gameOverNode = SKShapeNode(rectOf: size)
        gameOverNode.fillColor = .black.withAlphaComponent(0.8)
        gameOverNode.lineWidth = 0
        addChild(gameOverNode)
    }
    
    func setFont(label: SKLabelNode) {
        label.fontSize = 30
        let customFont = UIFont(name: "Menlo-Italic", size: 20)!
        label.fontName = customFont.fontName
        label.fontColor = #colorLiteral(red: 0.01476755552, green: 0.9785382152, blue: 1, alpha: 1)
    }
    
    func addBestScoreLabel(size: CGSize) {
        let bestScore = UserDefaults.standard.integer(forKey: "bestScore")
        let bestScoreText = "Best score: \(bestScore)"
        let bestScoreLabel = SKLabelNode(text: bestScoreText)
        setFont(label: bestScoreLabel)
        
        addChild(bestScoreLabel)
    }
    
    func addRestartLabel(size: CGSize) {
        let restartLabel = SKLabelNode(text: "TAP TO RESTART")
        setFont(label: restartLabel)
        restartLabel.position.y = self.frame.midY - restartLabel.frame.height * 5
        let action = SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            .moveBy(x: -10, y: 0, duration: 0.1),
            .moveBy(x: 20, y: 0, duration: 0.1),
            .moveBy(x: -10, y: 0, duration: 0.1)
        ])
        restartLabel.run(.repeatForever(action))
        addChild(restartLabel)
    }
    
    func addNewRecord(size: CGSize, isNewRecord: Bool) {
        let newRecord = "New Record!"
        let newRecordLabel = SKLabelNode(text: newRecord)
        setFont(label: newRecordLabel)
        newRecordLabel.position.y = self.frame.midY + newRecordLabel.frame.height * 5
        if isNewRecord {
            addChild(newRecordLabel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.restartCallBack()
    }
    
    
}
