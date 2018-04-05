//
//  Chase.swift
//  Slingshot
//
//  Created by Robert Desjardins on 2018-04-02.
//  Copyright © 2018 Robert Desjardins. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Chase: SKSpriteNode {
    func initChase() {
        self.name = GameData.shared.kObstacleName
        let chaseWidth = GameData.shared.deviceWidth * (1/9)
        let chaseHeight = chaseWidth
        self.size = CGSize(width: chaseWidth, height: chaseHeight)
        self.zPosition = 2
        
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
    }
}
