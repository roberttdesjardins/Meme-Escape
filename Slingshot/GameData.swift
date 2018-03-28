//
//  SpriteNames.swift
//  Slingshot
//
//  Created by Robert Desjardins on 2018-03-26.
//  Copyright © 2018 Robert Desjardins. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class GameData {
    static let shared = GameData()
    var kPlayerName = "playerName"
    var kObstacleName = "obstacleName"
    var deviceWidth = UIScreen.main.bounds.size.width
    var deviceHeight = UIScreen.main.bounds.size.height
    
    var playerScore = 0
    var playerHighScore: [Int] = []
    var creditsEarned: Int = 0
    var totalCredits: Int = 0

    private init() { }
}
