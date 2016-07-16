//: Playground - noun: a place where people can play

import Cocoa
import Foundation

//: # Memory

//let cal = NSCalendar(calendarIdentifier: "")

struct Person {
    let name: String
    var parents: [Person]
}

var john = Person(name: "John", parents: [])
john.parents = [john]
print(john)

class People {
    var name: String
    var parents: [People]
    
    init(name: String, parents: [People]) {
        self.name = name
        self.parents = parents
    }
}

class View {
    var window: Window
    init(window: Window) {
        self.window = window
    }
}

class Window {
    var rootView: View?
}

do {
    var window: Window? = Window()
    window = nil
}

var window: Window? = Window()
var view: View? = View(window: window!)
window?.rootView = view
view = nil
window = nil

//: ## Weak Reference
//: ## Unowned Reference
//: unowned还会保留

//: ## Structs and Classes in Practise
//: ### Using Class

typealias USDCents = Int

//class Account {
//    var funds: USDCents = 0
//    init(funds: USDCents) {
//        self.funds = funds
//    }
//}
//
//let alice = Account(funds: 100)
//let bob = Account(funds: 0)
//
//func transfer(ammount: USDCents, source: Account, destination: Account) -> Bool {
//    guard source.funds >= ammount else { return false }
//    source.funds -= ammount
//    destination.funds += ammount
//    return true
//}
//
//transfer(50, source: alice, destination: bob)

//: ### Using Structs

struct Account {
    var funds: USDCents
}

//func transfer(amount: USDCents, source: Account, destination: Account) -> (source: Account, destionation: Account)? {
//    guard source.funds > amount else { return nil }
//    var newSource = source
//    var newDestination = destination
//    newSource.funds -= amount
//    newDestination.funds += amount
//    return (newSource, newDestination)
//}

//: ### Using Struct inout
func transfer(amount: USDCents, inout source: Account, inout destination: Account) -> Bool {
    guard source.funds >= amount else { return false }
    source.funds -= amount
    destination.funds += amount
    return true
}

//: ## Closues and Memory

class Example {
    init() { print("init") }
    deinit { print("deinit") }
}

func newScope() {
    let example = Example()
    print("About to leave the scope")
}
newScope()

func capturingScope() -> () -> () {
    let example = Example()
    return { print(example) }
}

let z = capturingScope()

//: ### Closures reference cycles
class XMLReader {
    var onTagOpen:(tagName: String) -> ()
    var onTagClose: (tagName: String) -> ()
    
    init(url: NSURL) {
        onTagOpen = { _ in }
        onTagClose = { _ in }
    }
    
    func stop() {
        
    }
    
    deinit {
        print("reader deinit")
    }
}

class Controller {
    let reader: XMLReader = XMLReader(url: NSURL())
    var tags: [String] = []
    
    func viewDidLoad() {
        reader.onTagOpen = { [unowned self, weak myReader = self.reader] tagName in
            self.tags.append(tagName)
            if tagName == "stop" {
                myReader?.stop()
            }
        }
    }
    
    deinit {
        print("controller deinit")
    }
}

var controller: Controller? = Controller()
controller?.viewDidLoad()
controller = nil

//: # Case Stude: Game Design with Structs

//protocol Storage {
//    subscript(name: String) -> Int? { set get }
//}
//
//extension NSUserDefaults: Storage {
//    subscript(name: String) -> Int? {
//        get {
//            return (objectForKey(name) as? NSNumber)?.integerValue
//        }
//        set {
//            setObject(newValue, forKey: name)
//        }
//    }
//}

//class Player {
//    let health: Health
//    var chocolates: BoxOfChocolates?
//    let storage: Storage
//    
//    init(storage: Storage = NSUserDefaults.standardUserDefaults()) {
//        self.storage = storage
//        health = Health(storage: storage)
//    }
//    
//    func save() {
//        
//    }
//    
//    func study() {
////        
////    }
////}
//
//
//class Health {
//    
//    var foodPoint: Int = 100 {
//        didSet { save() }
//    }
//    
//    var experiencePoints: Int = 0 {
//        didSet { save() }
//    }
//    
//    var storage: Storage
//    
//    init(storage: Storage) {
//        self.storage = storage
//        foodPoint = storage["player.health"] ?? foodPoint
//        experiencePoints = storage["player.experience"] ?? experiencePoints
//    }
//    
//    func save() {
//        storage["player.health"] = foodPoint
//        storage["player.experience"] ?? experiencePoints
//    }
//}
//
//class BoxOfChocolates {
//    private var numberOfChocolates: Int = 10 {
//        didSet { save() }
//    }
//    var storage: Storage
//    
//    init(storage: Storage) {
//        self.storage = storage
//        numberOfChocolates = storage["player.chocolates"] ?? numberOfChocolates
//    }
//    
//    func save() {
//        storage["player.chocolates"] = numberOfChocolates
//    }
//    
//    func eat(player: Player) {
//        numberOfChocolates -= 1
//        player.health.foodPoint = min(100, player.health.foodPoint + 10)
//    }
//}

typealias PropertyList = [String: AnyObject]

struct Player {
    var health: Health
    var chocolates: BoxOfChocolates?
    
    init(properties: PropertyList = [:]) {
        let healthProperties = properties["health"] as? PropertyList
        health = Health(properties: healthProperties ?? [:])
        if let chocolatesProperties = properties["chocolates"] as? PropertyList {
            chocolates = BoxOfChocolates(properties: chocolatesProperties)
        }
    }
    
    mutating func study() {
        health.foodPoint -= 2
        health.experiencePoints += 1
    }
    
    func serialize() -> PropertyList {
        var result: PropertyList = [
            "health": health.serialize()
        ]
        result["chocolates"] = chocolates?.serialize()
        return result
    }
    
}

extension Player {
    mutating func eat() {
        guard let count = self.chocolates?.numberOfChocolates where count > 0 else { return }
        self.chocolates?.numberOfChocolates -= 1
        health.foodPoint = min(100, health.foodPoint + 10)
    }
}


struct Health {
    
    var foodPoint: Int = 100
    
    var experiencePoints: Int = 0
    
    init(properties: PropertyList) {
        foodPoint = properties["food"] as? Int ?? foodPoint
        experiencePoints = properties["experience"] as? Int ?? experiencePoints
    }
    
    func serialize() -> PropertyList {
        return [
            "food": foodPoint,
            "experience": experiencePoints
        ]
    }
    
    
}

struct BoxOfChocolates {
    private var numberOfChocolates: Int = 10
    
    init(properties: PropertyList) {
        numberOfChocolates = properties["chocolates"] as? Int ?? numberOfChocolates
    }
    
    func serialize() -> PropertyList {
        return [
            "chocolates": numberOfChocolates
        ]
    }
    
}

protocol Serializer {
    subscript(name: String) -> PropertyList? { set get }
}

extension NSUserDefaults: Serializer {
    subscript(name: String) -> PropertyList? {
        get {
            return (objectForKey(name) as? PropertyList)
        }
        set {
            setObject(newValue, forKey: name)
        }
    }
}



class GameState {
    var player: Player {
        didSet { save() }
    }
    var serializer: Serializer
    
    init(serializer: Serializer = NSUserDefaults.standardUserDefaults()) {
        self.serializer = serializer
        player = Player(properties: serializer["player"] ?? [:])
    }
    
    func save() {
        serializer["player"] = player.serialize()
    }
}
