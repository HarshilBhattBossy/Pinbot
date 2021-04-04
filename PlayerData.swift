//
//  PlayerData.swift
//  PinBot
//
 
//  Copyright © 2018 Harshil Bhatt. All rights reserved.
//

import Foundation

import ARKit
import CoreData


class PlayerData {
    /// PersonelData
    
    
    var Level = 0                          // Level
    var Money = 0
    var HighScore = 0
    var WeaponsOwned = [SCNNode]()
    var PurchasedLevels = ["Color Blur"]
    var AlreadyPurchasedWeapons = ["art.scnassets/Shoot.scn"]
    var PurchasedReaves = ["art.scnassets/GameModeScene.scn"]
    
    
    
    /// Retrive Data
    var Data = [GameData]()
    func Getdata() {
        let Context  =  (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        do {
            Data = try (Context?.fetch(GameData.fetchRequest()))!
        } catch {
            print("Could not retrive Data")
        }
    }
    func FirstTimeStartedGame(_ HighScores : [Int]) {
        //        let GamesFirstData = GameData()
        //        Data.append(GamesFirstData)
        let contexts = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        let AccountingRefrence = GameData(context: contexts!)
       
        Data.insert(AccountingRefrence, at: 0)
        Data[0].currentLevel = 0
        Data[0].playersAccount = 20
        Data[0].highScoreEachStage = HighScores as NSArray
        Data[0].purchasedLevels = ["Color Blur"] as NSArray
        Data[0].weapons = AlreadyPurchasedWeapons as NSArray
        Data[0].purchasedReaves = PurchasedReaves as NSArray
        /// Later
        print(Data[0])
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func AssignedValues() {
        Level = Int(Data[0].currentLevel)
        Money = Int(Data[0].playersAccount)
        //Data[0].highScoreEachStage
        PurchasedLevels =  Data[0].purchasedLevels as! [String]
        AlreadyPurchasedWeapons = Data[0].weapons as! [String]
        PurchasedReaves = Data[0].purchasedReaves as! [String]

    }
    
    func CheckFirstTime() -> Bool {
        if Data.isEmpty {
            print("True")
            FirstTimePlayer = true
            return true
            
        } else {
            GameClass.FirstHighScore = false   
            FirstTimePlayer = false 
            print("False")
            return false
            
        }
    }
    // FOR END GAMES FOR SCORE AND LEVEL
    func EndGameSavings(_ Score : Int) {
        // MONEY
        
        let PLayersAccounts = Data[0]
        let PLayersMoney = Int(PLayersAccounts.playersAccount)
        Money = PLayersMoney + Score
        Data[0].playersAccount = Int16(Money)
        // LEVEL
        // COMPLETE CHALLANGES
        PLayersAccounts.currentLevel += 1
        
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    // PURCAHASE RE VALUATE VALUES
    func Purchases(_ money : Int , level : Int , PurchasedLevel : String) {
        Money = Money - money
        Level = Level + level
        PurchasedLevels.append(PurchasedLevel)
        Data[0].playersAccount = Int16(Money)
        Data[0].currentLevel = Int16(Level)
        Data[0].purchasedLevels = PurchasedLevels as NSArray
        print(PurchasedLevels)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    func PurchaseWeaopon(_ money : Int , _ level : Int ,_  PurchasedLevel : String) {
        Money = Money - money
        Level = level + Level
        AlreadyPurchasedWeapons.append(PurchasedLevel)
        Data[0].playersAccount = Int16(Money)
        Data[0].currentLevel = Int16(Level)
        Data[0].weapons = AlreadyPurchasedWeapons as NSArray
        print("Saved")
        print(AlreadyPurchasedWeapons)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func PurchaseReavesFrom(_ money : Int , _ level : Int ,_  PurchasedLevel : String) {
        Money = Money - money
        Level = level + Level
        PurchasedReaves.append(PurchasedLevel)
        Data[0].playersAccount = Int16(Money)
        Data[0].currentLevel = Int16(Level)
        Data[0].purchasedReaves = PurchasedReaves as NSArray
        print("Saved")
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    
    
    func Purchasess(_ Category : String  , _ Moneys : Int , Levels : Int , PurchaseLevels : String)  {
        
        
        
        //  let PurchasingWeapon = PurchaseWeaopon(Moneys, level: Levels, PurchasedLevel : PurchaseLevels)
        //let PurchaseLevelsss = Purchases(Moneys, level: Levels , PurchasedLevel: PurchaseLevels)
        print("WORKED ->>")
        let item = PurchaseWeaopon
        let its = Purchases
        let ReavPurchase = PurchaseReavesFrom
        let Categorys = ["Weapon" : item, "Levels" :  its , "Reaves" : ReavPurchase ]
        //ArrayOfMethods[0]
        Categorys[Category]!(Moneys,  Levels,  PurchaseLevels)
        print("Money \(self.Money)")
        print("Above Says Alll- -")
    }
    
    
}
