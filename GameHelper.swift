//
//  GameState.swift
//  GuessCity
//
//  Created by Vladimir Cirkovic on 1/6/17.
//  Copyright © 2017 Vladimir Cirkovic. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit
import AVFoundation

public enum GameState {
    case Playing
    case TapToPlay
    case GameOver
}

class GameHelper {
    var state = GameState.TapToPlay

    var musicPlayer: AVAudioPlayer!
    var soundsPlayer: AVAudioPlayer!

    static let sharedInstance = GameHelper()

    var sounds = [String:SCNAudioSource]()
    var soundFiles = [String:String]()

    let bandColor: UIColor = UIColor(red: CGFloat(255/255.0), green: CGFloat(87/255.0), blue: CGFloat(51/255.0), alpha: CGFloat(1.0))
    let mainColor: UIColor = UIColor(red: CGFloat(244/255.0), green: CGFloat(244/255.0), blue: CGFloat(244/255.0), alpha: CGFloat(1.0))
    let pointsColor: UIColor = UIColor(red: CGFloat(255/255.0), green: CGFloat(243/255.0), blue: CGFloat(51/255.0), alpha: CGFloat(1.0))
    let positionColor: UIColor = UIColor(red: CGFloat(255/255.0), green: CGFloat(175/255.0), blue: CGFloat(51/255.0), alpha: CGFloat(1.0))

    init() {
    }

    static func random(maxValue: UInt32) -> UInt32 {
        return arc4random_uniform(maxValue + 1)
    }

    func playBackgroundMusic(filename: String) {
        let url = Bundle.main.url(forResource: filename, withExtension: nil)
        guard let newURL = url else {
            print("Could not find file: \(filename)")
            return
        }
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: newURL)
            musicPlayer.numberOfLoops = -1
            musicPlayer.volume = 0.5
            musicPlayer.prepareToPlay()
            musicPlayer.play()
        } catch let error as NSError {
            print(error.description)
        }
    }

    func muteBackgroundMusic() {
        if let p = musicPlayer {
            p.setVolume(0.3, fadeDuration: 2)
        }
    }

    func resumeBackgroundMusic() {
        if let p = musicPlayer {
            p.setVolume(0.5, fadeDuration: 2)
        }
    }

    func playSound(filename: String) {
        let url = Bundle.main.url(forResource: filename, withExtension: nil)
        guard let newURL = url else {
            print("Could not find file: \(filename)")
            return
        }
        do {
            soundsPlayer = try AVAudioPlayer(contentsOf: newURL)
            soundsPlayer.numberOfLoops = 0
            soundsPlayer.volume = 0.5
            soundsPlayer.prepareToPlay()
            soundsPlayer.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
}
