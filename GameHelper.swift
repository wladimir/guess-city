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
    case playing
    case tapToPlay
    case gameOver
}

class GameHelper {
    static let sharedInstance = GameHelper()

    var state = GameState.tapToPlay

    var musicPlayer: AVAudioPlayer!
    var soundsPlayer: AVAudioPlayer!
    var sounds = [String:SCNAudioSource]()
    var soundFiles = [String:String]()

    let bandColor: UIColor = UIColor(red: CGFloat(255/255.0), green: CGFloat(87/255.0), blue: CGFloat(51/255.0), alpha: CGFloat(1.0))
    let mainColor: UIColor = UIColor(red: CGFloat(244/255.0), green: CGFloat(244/255.0), blue: CGFloat(244/255.0), alpha: CGFloat(1.0))
    let pointsColor: UIColor = UIColor(red: CGFloat(255/255.0), green: CGFloat(243/255.0), blue: CGFloat(51/255.0), alpha: CGFloat(1.0))
    let positionColor: UIColor = UIColor(red: CGFloat(33/255.0), green: CGFloat(164/255.0), blue: CGFloat(63/255.0), alpha: CGFloat(1.0))

    let largeIcon = CGSize(width: 40, height: 40)
    let mediumIcon = CGSize(width: 30, height: 30)
    let smallIcon = CGSize(width: 20, height: 20)
    let margin: CGFloat = 25

    static func random(maxValue: UInt32) -> UInt32 {
        return arc4random_uniform(maxValue + 1)
    }

    func createMusicPlayer(filename: String) {
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
        } catch let error as NSError {
            print(error.description)
        }
    }

    func playBackgroundMusic() {
        if let p = musicPlayer {
            p.play()
        }
    }

    func stopBackgroundMusic() {
        if let p = musicPlayer {
            p.stop()
        }
    }

    func fadeOutBackgroundMusic() {
        if let p = musicPlayer {
            p.setVolume(0.0, fadeDuration: 2)
        }
    }

    func fadeInBackgroundMusic() {
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
