//
//  Knuckles.swift
//  Slingshot
//
//  Created by Robert Desjardins on 2018-03-29.
//  Copyright © 2018 Robert Desjardins. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Knuckles: SKSpriteNode {
    func initKnuckles() {
        self.name = GameData.shared.kObstacleName
        self.size = CGSize(width: GameData.shared.deviceWidth * (1/2), height: GameData.shared.deviceWidth * (1/2))
        self.zPosition = 2
        
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
    }
    
    func makeKnucklesRotate() {
        let oneRevolution:SKAction = SKAction.rotate(byAngle: CGFloat.pi * 2 * CGFloat.randomSign, duration: TimeInterval(random(min: 0.5, max: 1.0)))
        let repeatRotation:SKAction = SKAction.repeatForever(oneRevolution)
        
        self.run(repeatRotation)
    }

}

