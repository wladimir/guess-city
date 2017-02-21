//
//  SKLabelNode+Animations.swift
//  GuessCity
//
//  Created by Vladimir Cirkovic on 2/21/17.
//  Copyright © 2017 Vladimir Cirkovic. All rights reserved.
//

import Foundation
import SpriteKit

extension SKLabelNode {
//    https://github.com/l800891/CLTypingLabel

    func animate(newText: String, characterDelay: TimeInterval) {
        DispatchQueue.main.async {

            self.text = ""

            for (index, character) in newText.characters.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay * Double(index)) {
                    self.text?.append(character)
                }
            }
        }
    }
}
