//: [Previous](@previous)

import Foundation

//: # SubSequence and Generic Algorithms

// 这个会有错误
extension CollectionType where Generator.Element: Equatable, SubSequence.Generator.Element == Generator.Element {
    func search<Other: SequenceType where Other.Generator.Element == Generator.Element>(pattern: Other) -> Index? {
        for idx in self.indices {
            if suffixFrom(idx).startsWith(pattern) {
                return idx
            }
        }
        return nil
    }
}

extension CollectionType where Generator.Element: Equatable, SubSequence == Self {
    func search<Other: SequenceType where Other.Generator.Element == Generator.Element>(pattern: Other) -> Index? {
        for idx in self.indices {
            if suffixFrom(idx).startsWith(pattern) {
                return idx
            }
        }
        return nil
    }
}

var str = "Hello, playground"
"hello".characters.search("ell".characters)

//But as we saw in the collections chapter, the slice type for arrays is ArraySlice, so you could not search arrays. Therefore, we need to constrain a little less and instead require that the subsequences’ elements match:

//看不懂了这里
extension CollectionType where Generator.Element: Equatable, SubSequence.Generator.Element == Generator.Element {
    
}

//: # Overrides and Optimizations

extension CollectionType where Generator.Element: Equatable, Index: RandomAccessIndexType, SubSequence.Generator.Element == Generator.Element {
    func search<Other: CollectionType where Other.Index: RandomAccessIndexType, Other.Index.Distance == Index.Distance, Other.Generator.Element == Generator.Element>(pattern: Other) -> Index? {
        guard !isEmpty && pattern.count <= count else { return nil }
        
        for i in startIndex...endIndex.advancedBy(-pattern.count) {
            if self.suffixFrom(i).startsWith(pattern) {
                return i
            }
        }
        return nil
    }
}


//: # Designing With Generics
//
//func loadUsers(callback:[User]? -> ()) {
//    let usersURL = webser
//}


func loadResource<A>(pathComponent: String, parse: AnyObject->A?, callBack: A?->()) {
    let webServiceURL = NSURL(string: "")!
    let resourceURL = webServiceURL.URLByAppendingPathComponent(pathComponent)
    let data = NSData(contentsOfURL: resourceURL)
    let json = data.flatMap {
        try? NSJSONSerialization.JSONObjectWithData($0, options: NSJSONReadingOptions())
    }
    callBack(json.flatMap(parse))
}

struct User {
    var name: String
    init?(_ name: String) {
        self.name = name
    }
}

func jsonArray<A>(f: (AnyObject)->A?) -> AnyObject->[A]? {
    return { arr in
        (arr as? [AnyObject]).map{ $0.flatMap(f) }
    }
}

func loadUser2(callBack:[User]?->()) {
    loadResource("/users", parse: jsonArray { User.init($0 as! String)}, callBack: callBack)
}

struct Resource<A> {
    let pathComponent: String
    let parse: AnyObject -> A?
}

extension Resource {
    func loadSynchronous(callback: A?->()) {
        let webServiceURL = NSURL(string: "")!
        let resourceURL = webServiceURL.URLByAppendingPathComponent(self.pathComponent)
        let data = NSData(contentsOfURL: resourceURL)
        let json = data.flatMap {
            try? NSJSONSerialization.JSONObjectWithData($0, options: NSJSONReadingOptions())
        }
        callback(json.flatMap(self.parse))
    }
}
let userResource: Resource<[User]> = Resource(pathComponent: "/users", parse: jsonArray{User.init($0 as! String)})

extension Resource {
    func loadAsynchronous(callback: A?->()) {
        let webServiceURL = NSURL(string: "")!
        let session = NSURLSession.sharedSession()
        let resourceURL = webServiceURL.URLByAppendingPathComponent(pathComponent)
        
        session.dataTaskWithURL(resourceURL) { data, reponse, error in
            let json = data.flatMap {
                try? NSJSONSerialization.JSONObjectWithData($0, options: NSJSONReadingOptions())
            }
            callback(json.flatMap(self.parse))
        }.resume()
    }
}
