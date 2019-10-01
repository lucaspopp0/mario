//
//  SoundManager.swift
//  Platformer 2
//
//  Created by Lucas Popp on 1/13/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import AVFoundation

class Sound: NSObject {
    
    var id: Int!
    var player: AVAudioPlayer!
    
    init(id: Int, player: AVAudioPlayer) {
        self.id = id
        self.player = player
    }
    
}

class SoundManager {
    
    static var nextId: Int = 0
    
    static let shared: SoundManager = SoundManager()
    
    var sounds: [Sound] = []
    
    static var urls: [String: URL] = [:]
    
    func pauseAll() {
        for sound: Sound in sounds {
            sound.player.pause()
        }
    }
    
    static func initUrls() {
        let resources: [String] = [
            "Block Land", "Block Step", "Break Block", "Bump Block", "Coin Grab", "Grass Land Overworld",
            "Fireball", "Goal Pole", "Ground Land", "Ground Step", "Jump", "Kick", "Pipe", "Player Die",
            "Power Down", "Power Up", "Stomp", "Wall Jump", "Star Coin", "Starman Bounce", "Starman Ending",
            "Starman Music", "Level Clear", "Underground Music", "Fortress Music", "Castle Music",
            "Dry Bones Collapse", "Dry Bones Rebuild", "Grass Map Music", "Start Level", "Door Open",
            "Door Close"
        ]
        
        for name: String in resources {
            urls[name] = URL(fileURLWithPath: Bundle.main.path(forResource: name, ofType: "mp3")!)
        }
    }
    
    func loadSound(named name: String) -> Sound? {
        if let path = Bundle.main.path(forResource: name, ofType: "mp3") {
            return loadSound(url: URL(fileURLWithPath: path))
        } else {
            return nil
        }
    }
    
    func loadSound(url: URL) -> Sound? {
        do {
            let player: AVAudioPlayer = try AVAudioPlayer(contentsOf: url)
            let newSound: Sound = Sound(id: SoundManager.nextId, player: player)
            
            SoundManager.nextId += 1
            
            sounds.append(newSound)
            
            return newSound
        } catch {
            return nil
        }
    }
    
    func removeSound(_ sound: Sound) {
        for i in 0 ..< sounds.count {
            if sounds[i].id == sound.id {
                sounds.remove(at: i)
                break
            }
        }
    }
    
    func removeSounds(_ sounds: [Sound]) {
        for sound: Sound in sounds {
            removeSound(sound)
        }
    }
    
}
