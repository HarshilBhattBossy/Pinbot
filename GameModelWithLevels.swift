//
//  GameModelWithLevels.swift
//  PinBot
//
 
//  Copyright © 2018 Harshil Bhatt. All rights reserved.
//

// CHECK LIST 





import UIKit
import ARKit
import SceneKit
import StoreKit
import AVFoundation

enum LevelSuffencient : Error {
    case LevelLocked
}
var FirstTimePlayer = true
var ReviewTime = 0

class GameModelWithLevels: UIViewController  , UICollectionViewDelegate , UICollectionViewDataSource , ARSCNViewDelegate {
   
    @IBOutlet weak var DropUpOptions: UIVisualEffectView!
    @IBOutlet weak var SceneView: ARSCNView!
    @IBOutlet weak var collectionView : UICollectionView!

    @IBOutlet weak var PlayersMoney: UILabel!
    
    let ArrayOfGameRecord = Game().GameModeRecord
    
    
    
    
    var CurrentPurchaseList = Values.PurchasePrice
    let Particle = SCNParticleSystem(named: "Bokeh.scnp", inDirectory: nil)!
    // View INfO
    let Nodes = SCNNode()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        SceneView.delegate = self
        let Scene = SCNScene()
        SceneView.scene = Scene
        GameClass.GetData()
        PurchaseLabel.setTitle("", for: .normal)
        PlayersMoney.text = "\(GameClass.PlayerGameData.Money)💰"
        
        
        Nodes.position = SCNVector3(0 , 0 , -14)
        Nodes.addParticleSystem(Particle)
        SceneView.scene.rootNode.addChildNode(Nodes)
        
        // BRING DOWN UPGRADES SIDE
        BringDown()
        AssignValues()
        
        
        if ReviewTime == 2 || ReviewTime == 4 || ReviewTime == 6 {
            SKStoreReviewController.requestReview()
            
        }
        
//        var AudioFile = AVAudioPlayer()
//        do  {
//            AudioFile = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Shy Girl", ofType: "mp3")!)  )
//            AudioFile.prepareToPlay()
//            print("Worked")
//        } catch {
//            print(error)
//            print("Actual Errro")
//        }
       // AudioFile.play()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let configuration = ARWorldTrackingConfiguration()
        SceneView.session.run(configuration)
    }
    
    
    // CollectionViewInformartions
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ArrayOfAvaialablePurchase.FromHere[Tagss].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let CustomCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameString", for: indexPath) as! GameModecELL
       
        
       
        
        
        
       //let IndexRow = indexPath.row
        
        if collectionView == collectionView {
        CustomCell.GameName.text = ArrayOfAvaialablePurchase.ItemsName[Tagss][indexPath.row]
        print(ArrayOfGameRecord)
        } else {
            print("else")
            return CustomCell
        }
        
        
        return CustomCell
        
    }
    
    
    
    // DID SELECT ITEM
    var NodeTapped = SCNScene(named: "art.scnassets/Bullets1.scn")?.rootNode
    let TextNode = SCNNode()
   
    var IndexPathRow = 0 // CURRENT SELECTIONS FROM PURCHASE LIST
    var OwnedSelection = 0 // ONLY FOR LEVELS
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        DidMoveOn = true 
//         let CustomCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameString", for: indexPath) as! GameModecELL
       // CustomCell.backgroundColor = UIColor.red
        if CurrentMode != "Levels" {
            BringDown()
        }
       
        
        IndexPathRow = indexPath.row
        let ItemCurrentlySelected = AvailableItems[IndexPathRow]
        SelectLabel.setTitle("Select", for: .normal)
        // PURCHASED LEVELS
       
      if CurrentMode == "Levels" {
        if GameClass.PlayerGameData.PurchasedLevels.contains(Values.GamesModesAvailable[IndexPathRow]) {
            PurchaseLabel.setTitle("Owned", for: .normal)
            MoneySymbol.text = ""
            // IF CURRENT MODE = SELECTIONS
            if CurrentMode == "Levels" {
                MoveAroundLabel.text = GameClass.GameMode[IndexPathRow].Discription
            OwnedSelection = indexPath.row
            }
            
           
        } else {
            
            MoneySymbol.text = "\(ArrayOfAvaialablePurchase.PriceFromHere[Tagss][ItemCurrentlySelected] ?? 0)"
            SelectLabel.setTitle("Select", for: .normal)
            PurchaseLabel.setTitle("Purchase", for: .normal)
            
        }
        }
        
       
        // PURCHASED WEAPON
        
        if CurrentMode == "Weapon" || CurrentMode == "Reaves" {
            let String = ArrayOfAvaialablePurchase.FromHere[Tagss][IndexPathRow]
             let Text = SCNText(string: String, extrusionDepth: 0.1)
            TextNode.geometry = Text
            NodeTapped?.removeFromParentNode()
            TextNode.removeFromParentNode()
            
           
            NodeTapped = SCNScene(named: String)?.rootNode
            
             if CurrentMode == "Weapon" {
            NodeTapped?.eulerAngles.y = 0
            NodeTapped?.eulerAngles.x = -45
            NodeTapped?.eulerAngles.z = 78
            }
            guard let N = SceneView.session.currentFrame?.camera else {return }
            
            let S = SCNVector3(0   , N.transform.columns.3.y - 0.3 , N.transform.columns.3.z - 0.8 )
            NodeTapped?.position = S
            SceneView.scene.rootNode.addChildNode(NodeTapped!)
            SceneView.scene.rootNode.addChildNode(TextNode)
            
            
            
        }
        
        if CurrentMode == "Weapon" {
          if GameClass.PlayerGameData.AlreadyPurchasedWeapons.contains(AvailableItems[IndexPathRow]) {
            PurchaseLabel.setTitle("Owned", for: .normal)
            MoneySymbol.text = ""
          } else {
            
            MoneySymbol.text = "\(ArrayOfAvaialablePurchase.PriceFromHere[Tagss][ItemCurrentlySelected] ?? 0)"
            SelectLabel.setTitle("Select", for: .normal)
            PurchaseLabel.setTitle("Purchase", for: .normal)
            
            }
        }
        else if CurrentMode == "Reaves" {
        if GameClass.PlayerGameData.PurchasedReaves.contains(AvailableItems[IndexPathRow]) {
            PurchaseLabel.setTitle("Owned", for: .normal)
            MoneySymbol.text = ""
            
        } else {
            
            MoneySymbol.text = "\(ArrayOfAvaialablePurchase.PriceFromHere[Tagss][ItemCurrentlySelected] ?? 0)"
            SelectLabel.setTitle("Select", for: .normal)
            PurchaseLabel.setTitle("Purchase", for: .normal)
            
            }
        }
       
        
        
        
    }

    @IBOutlet weak var MoneySymbol: UILabel!
    @IBOutlet weak var PlayLabel: UIButton!
    
    
    // PLAY THE GAME WITH CURRENT SELECTED MODE
    @IBAction func Play(_ sender: Any) {
        print("\(OwnedSelection) PLayed")
        if GameClass.PlayerGameData.PurchasedLevels.contains(Values.GamesModesAvailable[OwnedSelection]) {
            GameClass.GameModeChosen = OwnedSelection
            
            
            if FirstTimePlayer == true {
            performSegue(withIdentifier: "PlayForFirstTime", sender: nil)
            } else {
            performSegue(withIdentifier: "GameTime", sender: nil)
            }
            
        }
        
    }
    
    @IBAction func PurchaseItem(_ sender: Any) {
        FinalPurchase()
    }
       
    // CHOOSE CURRENT MODE
    
    var CurrentMode = "Levels" // WHAT CATEGORY IS THE PLAYER PURCHASING
    var AvailableItems = ArrayOfAvaialablePurchase.FromHere[0] // FROM THE PURCHASE LIST
    var Tagss = 0 // REFRENCE FOR SELCTED LIST OF PURCHASING
    
    @IBOutlet weak var ReavesButton: UIButton!
    
    @IBOutlet weak var RocketButtons: UIButton!
    @IBOutlet weak var LevelsButton: UIButton!
    // CHOSE THE PURCHASE LIST
    @IBAction func ChoseUnit(_ sender: Any) {
        BringUp()
        let Sender = sender as! UIButton
        let Tag = Sender.tag
        Tagss = Tag
        let Valuess = ["Levels" , "Weapon" , "Reaves"]
        AvailableItems = ArrayOfAvaialablePurchase.FromHere[Tag]
        CurrentMode = Valuess[Tag]
        SelectLabel.setTitle("Select", for: .normal)
        collectionView.reloadData()
      
        
       
            ReavesButton.backgroundColor = UIColor.clear
            RocketButtons.backgroundColor = UIColor.clear
            LevelsButton.backgroundColor = UIColor.clear
        
        Sender.backgroundColor = #colorLiteral(red: 0.6683321221, green: 0.5262752881, blue: 0.06294096768, alpha: 1)
        
        
        
        
        
    }
    
    @IBOutlet weak var PurchaseLabel: UIButton!
    // SELECT CURRENT WEAOPON
    @IBAction func Select(_ sender: Any) {
        // WEAPON
        
  
        
    if CurrentMode == "Weapon" {
        if GameClass.PlayerGameData.AlreadyPurchasedWeapons.contains(ArrayOfAvaialablePurchase.FromHere[Tagss][IndexPathRow]) {
            
            GameClass.CurrentWeaponChosed = IndexPathRow
            let WeaponParts = WeaponUniqueFeatures.Name[GameClass.CurrentWeaponChosed].2
            let Particles = SCNParticleSystem(named: "\(WeaponParts)", inDirectory: nil)
            NodeTapped?.addParticleSystem(Particles!)
            SelectLabel.setTitle("Selected", for: .normal)
            
              SelectedChanged(IndexPathRow)
        }
        
        
        
        else{
                SelectLabel.setTitle("Purchase in order to select", for: .normal)
        }
     }
        // LEVELS
        if CurrentMode == "Levels" {
            MoveAroundLabel.text = "Purchase Levels"
            
            
            if GameClass.PlayerGameData.PurchasedLevels.contains(ArrayOfAvaialablePurchase.FromHere[Tagss][IndexPathRow]) {
                SelectLabel.setTitle("Selected", for: .normal)
                SelectedChanged(IndexPathRow)
                
            } else {
                SelectLabel.setTitle("Purchase Item", for: .normal)
            }
        } else {
            MoveAroundLabel.text = "Look Around there will be a Node"
        }
        
        if CurrentMode == "Reaves" {
            if GameClass.PlayerGameData.PurchasedReaves.contains(ArrayOfAvaialablePurchase.FromHere[Tagss][IndexPathRow]) {
                SelectLabel.setTitle("Selected", for: .normal)
                GameClass.CurrentReavesPurchased = IndexPathRow
                
                  SelectedChanged(IndexPathRow)
            } else {
                SelectLabel.setTitle("Purchase Item", for: .normal)
            }
            
        }
    }
    @IBOutlet weak var SelectLabel: UIButton!
    var ChangeColor = 1
    var RandomColors = [#colorLiteral(red: 1, green: 0.7102587155, blue: 0.2449874785, alpha: 1) , #colorLiteral(red: 0.7252180233, green: 0.04984934248, blue: 0.3192133052, alpha: 1) , #colorLiteral(red: 0.3738808787, green: 0.09934000689, blue: 0.5138444767, alpha: 1) ,#colorLiteral(red: 0.2602312372, green: 0.6801417151, blue: 0.5066473367, alpha: 1) ]
    
    // UPGRAF
    @IBOutlet weak var Upgrades: UIVisualEffectView!
    var UpgradesChosen = false
    @IBAction func UpgradesButton(_ sender: Any) {
        UpgradesBox()
        
    }
    
    func UpgradesBox() {
        if !UpgradesChosen {
            UIView.animate(withDuration: 1.0 , animations: {
                
                self.Upgrades.transform = CGAffineTransform(translationX: 0, y: 180)
            })
        } else {
            UIView.animate(withDuration: 0.5 , animations: {
                
                self.Upgrades.transform = CGAffineTransform.identity
            })
        }
        
        UpgradesChosen = !UpgradesChosen
    }
    
    func BringUp() {
        UIView.animate(withDuration: 0.5 , animations: {
            
            self.Upgrades.transform = CGAffineTransform.identity
        })
    }
    
    func BringDown() {
        UIView.animate(withDuration: 1.0 , animations: {
            
            self.Upgrades.transform = CGAffineTransform(translationX: 0, y: 180)
        })
    }
    
    // CORE DATA
    var LastData = [LastSavings]()
    
    @IBOutlet weak var MoveAroundLabel: UILabel!
    var DidMoveOn = false
    var Allowed = 1
    
    
}





















enum PurchaseError : Error {
    case NoMoney
    case AlreadyPurchased
}




// PURCHASE WEAOPONS
struct WeaponsMode  {
    static var BallNode = ["art.scnassets/Shoot.scn" : 0 , "art.scnassets/Bullets1.scn": 80 , "art.scnassets/TripleMian.scn" : 120  ,  "art.scnassets/Christmas.scn" : 180 , "art.scnassets/PlexaarShipssNoLIghts.scn" : 200 ,"art.scnassets/ShipsPlexarBetter 2.scn" : 220 ]
    static var PurchasePrice = ["art.scnassets/Shoot.scn" , "art.scnassets/Bullets1.scn" , "art.scnassets/TripleMian.scn" , "art.scnassets/Christmas.scn" , "art.scnassets/PlexaarShipssNoLIghts.scn",  "art.scnassets/ShipsPlexarBetter 2.scn"]
    static var Items = ["Egio" , "DopStrinz" , "Triple Dian" , "Christmas Special" , "SpaceTroop" , "Fighter Striker"] // "Crackizeda"
}
// PURCHASE LEVELS
struct Values {
    static var Score = 0
    static var GamesModesAvailable = ["Color Blur", "Shape Cure" , "ColShape Sure" , "WringHits" , "RANXING"]
    static var PurchasePrice =  ["Color Blur" : 0 , "Shape Cure" : 50 , "ColShape Sure" : 180 , "WringHits" : 240, "RANXING" :260]
    static var Items = ["Color Blur", "Shape Cure" , "ColShape Sure" , "WringHits" , "RANXING"]
}

struct Reaves {
    static let GameModesAvaialble = ["art.scnassets/GameModeScene.scn" , "SsenneGame.scn"  , "LevelBeast.scn" , "ChristmasTube.scn", "plexarTubeFGotta.scn"  , "art.scnassets/Amazing.scn", "NewssAugmentedThis.dae"]
    static let PurchasePrice = ["art.scnassets/GameModeScene.scn" : 0 , "SsenneGame.scn" : 170 , "LevelBeast.scn" : 290 , "ChristmasTube.scn" : 220 , "plexarTubeFGotta.scn" : 190 , "art.scnassets/Amazing.scn" : 300 ,"NewssAugmentedThis.dae" : 1]
    static let ItemsName = ["Plerized" , "Cimplexar" , "Plosture" , "Chriptos" , "Cyrindo" , "Read star" , "Demo Remove"]
}


// STORED PURCHASE LIST 
struct ArrayOfAvaialablePurchase {
    // NAMES TO BE ADDED TO PLAYER DATA , PURCHASE ARRAY
    static let FromHere = [Values.GamesModesAvailable , WeaponsMode.PurchasePrice , Reaves.GameModesAvaialble]
    // PRICE FROM HERE IS SPENT BY THE PLAYERS FOR ITEMS
    static let PriceFromHere = [Values.PurchasePrice , WeaponsMode.BallNode ,  Reaves.PurchasePrice]
    static let CollectionViewPurchase = [Values.Items , WeaponsMode.Items , Reaves.ItemsName]
    // ITEMS NAME AS PER USERS SCREEN
    static let ItemsName = [Values.Items , WeaponsMode.Items , Reaves.ItemsName]
    
}
extension Dictionary {
    func GetArray() -> Array<Any> {
        var Arrays = [Any]()
        for (Name , _ ) in self {
            Arrays.append(Name)
        }
        return Arrays
        
    }
}



// PURCHASING FUNCTIONS
extension GameModelWithLevels {
    func Purchasing(_ Money : Int , _ Item : String  , _ Category : String)throws  {
        guard GameClass.PlayerGameData.Money > Money else {throw PurchaseError.NoMoney}
        GameClass.PlayerGameData.Purchasess(Category, Money, Levels: 5, PurchaseLevels: Item)
        PlayersMoney.text = "\(GameClass.PlayerGameData.Money)"
    }
    
    func FinalPurchase() {
        if GameClass.PlayerGameData.AlreadyPurchasedWeapons.contains(AvailableItems[IndexPathRow]) {}
        else if GameClass.PlayerGameData.PurchasedLevels.contains(AvailableItems[IndexPathRow]) {}
        else if GameClass.PlayerGameData.PurchasedReaves.contains(AvailableItems[IndexPathRow]) {}
        else {
            do {
                let ItemCurrentlySelected = AvailableItems[IndexPathRow]
                let Price = ArrayOfAvaialablePurchase.PriceFromHere[Tagss][ItemCurrentlySelected]
                print("Price \(String(describing: Price))")
                // MAIN PURCJHASE
                try Purchasing(Price! , "\(ItemCurrentlySelected)", CurrentMode)
                if CurrentMode == "Levels" {
                OwnedSelection = IndexPathRow
                }
                PurchaseLabel.setTitle("Owned", for: .normal)
                MoneySymbol.text = ""
                SelectLabel.setTitle("Selected", for:  .normal)
                
                if CurrentMode == "Reaves" {
                    GameClass.CurrentReavesPurchased = IndexPathRow
                }
               
                
                
                
                if CurrentMode == "Weapon" {
                let WeaponParts = WeaponUniqueFeatures.Name[GameClass.CurrentWeaponChosed].2
                let Particles = SCNParticleSystem(named: "\(WeaponParts)", inDirectory: nil)
                GameClass.CurrentWeaponChosed = IndexPathRow
                NodeTapped?.addParticleSystem(Particles!)
                }
                
                
            } catch PurchaseError.NoMoney {
                SelectLabel.setTitle("Not enough money", for: .normal)
                print("NOT ENOUGH MONEY")
            }
            catch {
                print("Error 404 NOT found")
            }
        }
    }
    
    
  
}

extension GameModelWithLevels : SCNPhysicsContactDelegate{
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        if Allowed < Int(time) {
        if DidMoveOn {
            let Colors = [UIColor.red , UIColor.black , UIColor.yellow ]
            let Random = Int.random(in: 0..<Colors.count)
            MoveAroundLabel.textColor = Colors[Random]
            Allowed = 1 + Int(time)
            
        }
        
        }
        
        if ChangeColor < Int(time) {
            let RandomColorsInt = Int.random(in: 0..<RandomColors.count)
           
            Particle.particleColor = RandomColors[RandomColorsInt]
            ChangeColor = 1 + Int(time)
            let Colors = [UIColor.red , UIColor.black , UIColor.yellow ]
            let Random = Int.random(in: 0..<Colors.count)
            MoveAroundLabel.textColor = Colors[Random]
            
        }
        
        guard let N = SceneView.session.currentFrame?.camera else {return }
        
        let S = SCNVector3(N.transform.columns.3.x - 3  , N.transform.columns.3.y , N.transform.columns.3.z - 9 )
        Nodes.position = S
        
       
        
    }
}




extension GameModelWithLevels {
 
    func GetData() {
       
            let Context  =  (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
            do {
                LastData = try (Context?.fetch(LastSavings.fetchRequest()))!
               
            } catch {
                print("Could not retrive Data")
            }
        
        
    }
    
    func RetriveData() -> Bool {
        if LastData.count == 0 {
            return true
        } else {
            return false
        }
    }
    
    func AssignFirstTimeValues() {
        
            LastData[0].lastLevelSelected = 0
            LastData[0].lastReavesSelected = 0
            LastData[0].lastWeaponSelected = 0
            LastData[0].reviewTold = 0
    }
    func SelectedChanged(_ IndexValue : Int) {
        let Valuess = ["Levels" , "Weapon" , "Reaves"]
        if CurrentMode == "Levels" {
            LastData[0].lastLevelSelected = Int16(IndexValue)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        } else if CurrentMode == Valuess[1] {
            LastData[0].lastWeaponSelected = Int16(IndexValue)
        } else {
            LastData[0].lastReavesSelected = Int16(IndexValue)
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
         print(LastData[0])
    }
    
    func AssignValues() {
        GetData()
       
        
        
        if LastData.isEmpty == false   {
           
            GameClass.CurrentWeaponChosed = Int(LastData[0].lastWeaponSelected)
            GameClass.GameModeChosen = Int(LastData[0].lastLevelSelected)
            GameClass.CurrentReavesPurchased = Int(LastData[0].lastReavesSelected)
            ReviewTime = Int(LastData[0].reviewTold)
            ReviewTime = ReviewTime + 1
            LastData[0].reviewTold = Int16(ReviewTime)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        } else {
            
            
            
            
            let contexts = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
            let AccountingRefrence = LastSavings(context: contexts!)
            LastData.removeAll()
            LastData.insert(AccountingRefrence, at: 0)
            print("First time")
            AssignFirstTimeValues()
            LastData[0].itIsFirstTime = false
            
           
        }
        
        
         (UIApplication.shared.delegate as! AppDelegate).saveContext()
         print(LastData[0])
    }
    
    
    
    
}


