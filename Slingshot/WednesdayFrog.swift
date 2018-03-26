//
//  WednesdayFrog.swift
//  Slingshot
//
//  Created by Robert Desjardins on 2018-03-26.
//  Copyright © 2018 Robert Desjardins. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import AVFoundation

class WednesdayFrog: SKSpriteNode {
    
    func initWednesdayMyDudes(position: CGPoint) {
        self.name = GameData.shared.kObstacleName
        self.size = CGSize(width: 65, height: 65)
        self.zPosition = 2
        self.zRotation = random(min: 0, max: 6.28319)
        self.position = position
        
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
    }
    
    func makeFrogMove() {
        
        let randomDX = random(min: -250, max: 250)
        let randomDY = random(min: 450, max: 650)
        self.physicsBody?.applyForce(CGVector(dx: randomDX, dy: randomDY))
        
        let oneRevolution:SKAction = SKAction.rotate(byAngle: CGFloat.pi * 2 * CGFloat.randomSign, duration: TimeInterval(random(min: 0.5, max: 3.0)))
        let repeatRotation:SKAction = SKAction.repeatForever(oneRevolution)
        
        self.run(repeatRotation)
        
        let actionWait = SKAction.wait(forDuration: 5)
        let actionWaitDone = SKAction.removeFromParent()
        self.run(SKAction.sequence([actionWait, actionWaitDone]))
        
    }
}

