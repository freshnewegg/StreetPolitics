//
//  FightingBrain.swift
//  PartisanLines
//
//  Created by Edgar Wang on 2016-04-27.
//  Copyright (c) 2016 Edgar Wang. All rights reserved.
//

import Foundation
import SpriteKit

class FightingBrain{
    
    //state of the collision bitmask
    enum CollisionTypes: UInt32{
        case PLAYER1 = 0b001
        case PLAYER2 = 0b010
        case HITBOX = 0b100
        case GROUND = 0b1000
    }
    
    //players
    var player1 : Player? = nil
    var player2 : Player? = nil
    
    //time for hitbox management
    private var timeHitboxActivated: CFTimeInterval = 0
    
    var myScene : Fighting_Scene? = nil
    
    var queue = Queue<Player.actionState>()
    
    func createPlayer() -> Player?{
        if (player1 == nil){
            player1 = Player(spriteName: "trump" , xStartPosition: 200)
            return player1
        } else{
            player2 = Player(spriteName: "hilary", xStartPosition: 500)
            return player2
        }
    }
    
    //send action to server
    func addAction(currentAction: Player.actionState){
        queue.enQueue(currentAction)
        self.execute()
    }
    
    //receive action from server
    func execute(){
        var tmpAction : Player.actionState = self.queue.deQueue()!
        switch tmpAction{
        case .ATTACK:
            if let tmp = (player1?.attack()){
                myScene?.addChild(tmp)
            }
        case .BLOCK:
            player1?.block()
        case .MOVELEFT:
            player1?.moveLeft()
        case .MOVERIGHT:
            player1?.moveRight()
        case .NEUTRAL:
            player1?.neutral()
        }
        myScene?.displayAction(tmpAction)
    }
    
    func isEmpty() -> Bool{
        return self.queue.isEmpty()
    }
    
    func updateWithTimeSinceLastUpdate(timeSinceLastUpdate: CFTimeInterval) {
        // If it's been more than a second since we spawned the last alien,
        // spawn a new one
        if (player1?.state == Player.actionState.ATTACK){
            timeHitboxActivated += timeSinceLastUpdate
            if (timeHitboxActivated > 0.8) {
                timeHitboxActivated = 0
                player1?.neutral()
            }
        }
    }
}