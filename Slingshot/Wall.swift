//
//  Wall.swift
//  Slingshot
//
//  Created by Robert Desjardins on 2018-03-26.
//  Copyright © 2018 Robert Desjardins. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Wall: SKSpriteNode {
    func initWall(position: CGPoint) {
        self.name = GameData.shared.kObstacleName
        self.size = CGSize(width: 30, height: GameData.shared.deviceHeight * (1/2))
        self.zPosition = 2
        self.position = position
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
    }
}
