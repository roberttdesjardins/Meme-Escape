//
//  Triple.swift
//  Slingshot
//
//  Created by Robert Desjardins on 2018-03-28.
//  Copyright © 2018 Robert Desjardins. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import AVFoundation

class HitMarker: SKSpriteNode {
    func initHitMarker(position: CGPoint) {
        self.name = GameData.shared.kObstacleName
        self.size = CGSize(width: 50, height: 50)
        self.zPosition = 1
        self.position = position
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
    }
    
}

