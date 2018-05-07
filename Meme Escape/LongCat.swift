//
//  LongCat.swift
//  Slingshot
//
//  Created by Robert Desjardins on 2018-04-02.
//  Copyright © 2018 Robert Desjardins. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class LongCat: SKSpriteNode {
    func initLongCat() {
        self.name = GameData.shared.kObstacleName
        let longCatWidth = GameData.shared.deviceWidth * (1/4)
        let longCatHeight = longCatWidth * 4.6296296296
        self.size = CGSize(width: longCatWidth, height: longCatHeight)
        self.zPosition = 2
        
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
    }
    
    func moveLongCatUp() {
        let actionMove1 = SKAction.move(to: CGPoint(x: self.position.x, y: GameData.shared.deviceHeight/2), duration: TimeInterval(1.5))
        let actionWait = SKAction.wait(forDuration: 4.0)
        let actionMove2 = SKAction.move(to: CGPoint(x: self.position.x, y: GameData.shared.deviceHeight + self.size.height/2), duration: TimeInterval(1.5))
        let actionMoveDone = SKAction.removeFromParent()
        run(SKAction.sequence([actionMove1, actionWait, actionMove2, actionMoveDone]))
    }
    
    func moveLongCatDown() {
        let actionMove1 = SKAction.move(to: CGPoint(x: self.position.x, y: GameData.shared.deviceHeight/2), duration: TimeInterval(1.5))
        let actionWait = SKAction.wait(forDuration: 4.0)
        let actionMove2 = SKAction.move(to: CGPoint(x: self.position.x, y:  -self.size.height/2), duration: TimeInterval(1.5))
        let actionMoveDone = SKAction.removeFromParent()
        run(SKAction.sequence([actionMove1, actionWait, actionMove2, actionMoveDone]))
    }
}
