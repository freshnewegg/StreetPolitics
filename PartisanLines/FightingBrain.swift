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
    //actions for the players
    enum action{
        case MOVERIGHT
        case MOVELEFT
        case ATTACK
        case COUNTER
    }
    
    var queue = Queue<action>()
    
    //send action to server
    func addAction(currentAction: action){
         queue.enQueue(currentAction)
    }
    
    //should return the next action
    func getNext() -> FightingBrain.action?{
        if (!self.queue.isEmpty()){
            return self.queue.deQueue()
        } else{
            return nil
        }
    }
    
    func isEmpty() -> Bool{
        return self.queue.isEmpty()
    }
}