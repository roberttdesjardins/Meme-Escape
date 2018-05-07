//
//  Player.swift
//  Slingshot
//
//  Created by Robert Desjardins on 2018-03-24.
//  Copyright © 2018 Robert Desjardins. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import AVFoundation

class Player: SKSpriteNode {
    
    var runSpeed:CGFloat =  3
    var playerWidth:CGFloat = 40
    var playerHeight:CGFloat = 40
    
    func initPlayer() {
        self.size = CGSize(width: playerWidth, height: playerHeight)
        self.zPosition = 6
        self.name = GameData.shared.kPlayerName
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        self.physicsBody!.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.Player
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Edge
        self.physicsBody?.collisionBitMask = PhysicsCategory.Edge
    }
    
}
