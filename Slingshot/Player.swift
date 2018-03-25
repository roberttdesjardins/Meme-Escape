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
    
    func makeJump() {
        
        let jumpUp:SKAction = SKAction.moveBy(x: 0, y: 80, duration: 1)
        let fallDown:SKAction = SKAction.moveBy(x: 0, y: -80, duration: 1)
        
        let seq:SKAction = SKAction.sequence( [ jumpUp, fallDown ])
        
        self.run(seq)
        
    }
    
}
