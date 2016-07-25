//: Playground - noun: a place where people can play

import UIKit

//: #

enum Result<A> {
  case Failure(ErrorType)
  case Success(A)
}

//func contentsOfFile1(filename: String) -> String?

enum FileError: ErrorType {
  case FileDoesNotExist
  case NoPermission
}

//func contentsOfFile(filename: String) -> Result<String> {
//  return .Success("1")
//}
//


func contentsOfFile(filename: String) throws -> String {
  return "file"
}

enum ParseError: ErrorType {
  case WrongEncoding
  case Warning(line: Int, message: String)
}

enum  Result1<A, Error> {
  case Failure(Error)
  case Success(A)
}

//func parseFile(conenets: String) -> Result1<[String], ParseError>

func checkFile(contents: String) throws -> Bool {
  return true
}


func checkAllFiles(filenames: [String]) throws -> Bool {
  for filename in filenames {
    guard try checkFile(filename) else { return false }
  }
  return true
}



extension SequenceType {
  func all(@noescape check: Generator.Element throws -> Bool) rethrows -> Bool {
    for el in self {
      guard try check(el) else { return false }
    }
    return true
  }
}

func isPrime(num: Int) -> Bool {
  return true
}

func checkPrimes(numbers: [Int]) -> Bool {
  return numbers.all(isPrime)
}

//defer
//“If there are multiple defer blocks in the same scope, they are executed in reverse order” like stack


func parseFile(conenets: String) throws -> String {
  return "file"
}

if let contents = try? parseFile("") {
  print(contents)
}

func optional<A>(value: A?, orError e: ErrorType) throws -> A {
  guard let x = value else { throw e }
  return x
}

enum ReadIntError: ErrorType {
  case CouldNotRead
}
var opint = Int("42w")
let int: Int = try optional(opint, orError: ReadIntError.CouldNotRead)

//: # Chaining Errors

func checkFilesAndFetchProcessID(filenames: [String]) -> Int {
  do {
    try filenames.all(checkFile)
    let contents = try contentsOfFile("Pidfile")
    return try optional(Int(contents), orError: ReadIntError.CouldNotRead)
  }catch {
    return 42
  }
}

//func checkFilesAndFetchProcessID(filenames: [String]) -> Result<Int> {
//  return filenames.all( checkFile).flatMap
//}


//: # Higher-Order Functions and Errors

//func compute(callback: Int->()) {
//  
//}
//
//compute { result in
//  print(result)
//}

// func compute(callback: Int? -> ())
// func compute(callback: Int throws -> ())
// func compute(callback: Int -> Result<()>) // 这个比较好
// func compute(callback: Result<Int> -> ())
func compute(f: (() throws -> Int) -> ()) {
  
}

compute { (theResult: ()throws -> Int) in
  do {
    let result = try theResult()
    print(result)
  }catch {
    print("an error happened:\(error)")
  }
}
