//
//  AirHorn.swift
//  Slingshot
//
//  Created by Robert Desjardins on 2018-03-28.
//  Copyright © 2018 Robert Desjardins. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class AirHorn: SKSpriteNode {
    func initHorn() {
        self.name = GameData.shared.kObstacleName
        self.size = CGSize(width: GameData.shared.deviceHeight * (1/2), height: GameData.shared.deviceHeight * (1/2))
        self.zPosition = 2
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
    }
    
    
}
