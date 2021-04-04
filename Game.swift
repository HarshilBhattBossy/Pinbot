//
//  Game.swift
//  PinBot
//
 
//  Copyright © 2018 Harshil Bhatt. All rights reserved.
//

import Foundation
import SceneKit
import ARKit
import UIKit
import CoreData

struct Collisions  {
    static let Ship = 1 << 1
    static let Boxes = 1 << 2
}




struct Weapon  {
   
    var CheckForTime = 20
   
    
    
    /// Shooter Shoots Bullet
    mutating func  GetShooter(Direction : SCNVector3 , simdTransform: simd_float4x4)-> SCNNode {
       
       let Nodes = ArrayOfAvaialablePurchase.FromHere[1]
       let GameClassWeaponChose = GameClass.CurrentWeaponChosed
       let BallNode = SCNScene(named: "\(Nodes[GameClassWeaponChose])")!.rootNode
       
        
        
       
        let WeaponParticles = WeaponUniqueFeatures.Name[GameClassWeaponChose].1
        let S  =  BallNode.childNode(withName: "Shooters", recursively: true)
           
        let SS  =  BallNode.childNode(withName: "Shooters1", recursively: true)
        let Particle = SCNParticleSystem(named: WeaponParticles , inDirectory:  nil)
        S?.addParticleSystem(Particle!)
        SS?.addParticleSystem(Particle!)
            
            
            
        // WEAPON 4
        let Name = ["Name" , "Name1" , "Name2" , "Name3"]
        let Outside = BallNode.childNode(withName: "sphere", recursively: false)
        for n in Name {
           let Names = Outside?.childNode(withName: "\(n)", recursively: false)
           Names?.addParticleSystem(Particle!)
        }
 
        
        
       
        
//        BallNode.addParticleSystem(SCNParticleSystem(named: "FirstBlend.scnp", inDirectory: nil)!)
        
        BallNode.physicsBody?.categoryBitMask = Collisions.Ship
        BallNode.physicsBody?.contactTestBitMask = Collisions.Boxes
        
       
        BallNode.physicsBody = .dynamic()
        BallNode.physicsBody?.applyForce(Direction, asImpulse: true)
        BallNode.simdTransform = simdTransform
        
        /// Remove it Wait
        BallNode.name = "Ball"
       
        
       
        
        let Hide = SCNAction.fadeOut(duration: 0.3)
        BallNode.runAction(.sequence([.wait(duration : 6) , Hide]))
        
        
        return BallNode
    }
    
    
    
    
}



class Game {
    // EVERY GAME THIS IS NEEDED
    // var Bullets = 0
    var Level = 0  //Level of aggressive
    var Time = 0.0
    var TimeForWait = 1 // Time starts from 35 Seconds
    var Score = 0
    
    var PlayerGameData = PlayerData()
    // WEAOPON
    // IF FIRST TIME THEN DONT CELEBERATE
    var FirstHighScore = true
    
    
    
    var CurrentWeaponChosed = 0
    var CurrentReavesPurchased = 0
    var CurrentWeapon = Weapon()
    func GetData() {
        // Run Data to Recive CurrentStatus
        PlayerGameData.Getdata()
        // FOR FIRST TIME RUN ONLY
        var HighScoreData = [Int]()
        if PlayerGameData.CheckFirstTime()  {
        
            for _ in GameMode {
                HighScoreData.append(0)
            }
            PlayerGameData.FirstTimeStartedGame(HighScoreData)
            PlayerGameData.Data[0].highScoreEachStage = HighScoreData as NSArray
            PlayerGameData.Data[0].firstTime = false
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        }
        
        PlayerGameData.AssignedValues()
    }
    
    
    
    
    var GameModeChosen = 1
    var TimeEverySecond = 0  /// Each Second decrease value of Time
    
    
    
   
   
    var GameMode : [GameModesMinRequiresMents] = [ColorGameModel() , ShapeGameModel() , ColorWithShapeModel() , NotColorType() , AnyThing()] as! [GameModesMinRequiresMents]
    let GameModeRecord = Values.GamesModesAvailable // FOR COLLECTION VIEW
   
    

    
    
   
    // TIME
    // TIME
    func DecreaseTime(_ time : Int) {
        guard Time > 0 || Time > 0.0  else {return}
        Time = Time - 1.0
        TimeEverySecond = time + 1
    }
    func DecreaseTimeby2() {
        guard Time > 0 else {return}
        Time = Time - 2.0
    }
    // SCORE
    func IncreaseScore(_ ScoreBy : Int) {
        Score += ScoreBy
    }
    // IN A ROW
    func IfHit5andMoreIncreaseTime() {
        Time += 5
    }
    
    // TIME UP OR FINISHED GAME
    var PausedGame = false
    func ConstantCheckIfTrueLost()-> Bool {
        guard Time >= 1.0 else {
            PausedGame = true
            return true
        }
        
        
        PausedGame = false
        return false
    }
    // RESET
    func Reset() {
        Time = GameMode[GameModeChosen].Time
        
        Score = Values.Score
        PausedGame = false
    }
   

    func RunBeforeGame() {
        Time = GameMode[GameModeChosen].Time
    }
    

    
   
    
    
    
    
    
}
extension Int {
    var DegreesToRadians : CGFloat {
        return CGFloat(self) * .pi / 180
    }
}
enum CheckSeconds : Int {
    case CheckTimeEverySecond = 1  /// Check time every 1 SECOND
    
}


