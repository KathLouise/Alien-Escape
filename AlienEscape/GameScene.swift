//
//  GameScene.swift
//  AlienEscape
//
//  Created by Katheryne Graf on 19/04/19.
//  Copyright © 2019 Katheryne Graf. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var playerNode : SKSpriteNode!
    var enemyNode : SKSpriteNode!
    var enemyVelocity : CGPoint!
    var lastUpdateTime = CFTimeInterval()
    var gameOverNode : SKLabelNode!
    var gameOver = false
    var coinNode : SKSpriteNode!
    var scoreNode : SKLabelNode!
    var nCoins = 0
    var explosionSound : SKAction!
    var coinSound : SKAction!
    
    override func didMove(to view: SKView) {
        playerNode = self.childNode(withName: "Player") as? SKSpriteNode
        enemyNode = self.childNode(withName: "Enemy") as? SKSpriteNode
        gameOverNode = self.childNode(withName: "GameOverText") as? SKLabelNode
        coinNode = self.childNode(withName: "Coin") as? SKSpriteNode
        scoreNode = self.childNode(withName: "Score") as? SKLabelNode
        gameOverNode.isHidden = true
        playerNode.zPosition = 1.0
        enemyNode.zPosition = 1.0
        gameOverNode.zPosition = 1.0
        coinNode.zPosition = 1.0
        scoreNode.zPosition = 1.0
        
        enemyVelocity = CGPoint(x: 300.0, y: 300.0)
        explosionSound = SKAction.playSoundFileNamed("explosion", waitForCompletion: false)
        coinSound = SKAction.playSoundFileNamed("coin", waitForCompletion: false)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(gameOver){
            restartGame()
        }
        
        let touch = touches.first
        let location = touch!.location(in: self)
        playerNode.position = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch!.location(in: self)
        playerNode.position = location
    }
    
    override func update(_ currentTime: TimeInterval) {
        var timeSinceLastUpdate = 0.0
        if(lastUpdateTime != 0){
            timeSinceLastUpdate = currentTime - lastUpdateTime
        }
        lastUpdateTime = currentTime
        
        enemyNode.position.x += enemyVelocity.x * CGFloat(timeSinceLastUpdate)
        enemyNode.position.y += enemyVelocity.y * CGFloat(timeSinceLastUpdate)
        
        if(enemyNode.position.x < -(scene?.frame.width)!/2.0){
            enemyNode.position.x = -(scene?.frame.width)!/2.0
            enemyVelocity.x *= -1
        }
        
        if(enemyNode.position.x > (scene?.frame.width)!/2.0){
            enemyNode.position.x = (scene?.frame.width)!/2.0
            enemyVelocity.x *= -1
        }
        
        if(enemyNode.position.y < -(scene?.frame.height)!/2.0){
            enemyNode.position.y = -(scene?.frame.height)!/2.0
            enemyVelocity.y *= -1
        }
        
        if(enemyNode.position.y > (scene?.frame.height)!/2.0){
            enemyNode.position.y = (scene?.frame.height)!/2.0
            enemyVelocity.y *= -1
        }
        
        //verifica colisao
        if(playerNode.intersects(enemyNode)){
            if(!playerNode.isHidden){
                endGame()
            }
        }
        
        if(!gameOver){
            if(playerNode.intersects(coinNode)){
                AddScore()
            }
        }
    }
    
    func endGame(){
        playerNode.isHidden = true
        gameOver = true
        gameOverNode.isHidden = false
        
        run(explosionSound)
    }
    
    func restartGame(){
        playerNode.isHidden = false
        gameOver = false
        gameOverNode.isHidden = true
        
        nCoins += 0
        scoreNode.text = String(nCoins)
    }
    
    func AddScore(){
        nCoins += 1
        scoreNode.text = String(nCoins)
        
        let randX = arc4random_uniform(UInt32(self.frame.width))
        let randY = arc4random_uniform(UInt32(self.frame.height))
        
        coinNode.position.x = CGFloat(randX) - self.frame.width/2.0
        coinNode.position.y = CGFloat(randY) - self.frame.height/2.0
        
        run(coinSound)
    }
}
