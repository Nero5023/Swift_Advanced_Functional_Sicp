//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

//struct GaussianBlur {
//  private var filter: CIFilter
//  
//  init(inputImage: CIImage, raidus: Double) {
//    filter = CIFilter(name: "CIGaussianBlur",
//          withInputParameters: [
//            kCIInputImageKey: inputImage,
//            kCIInputRadiusKey: raidus
//      ])!
//  }
//}
//
//extension GaussianBlur {
//  private var filterForWriting: CIFilter {
//    mutating get {
//      filter = filter.copy() as! CIFilter
//      return filter
//    }
//  }
//}
//
//extension GaussianBlur {
//  var inputImage: CIImage {
//    get { return filter.valueForKey(kCIInputImageKey) as! CIImage }
//    set { filterForWriting.setValue(newValue, forKey: kCIInputImageKey) }
//  }
//  
//  var radius: Double {
//    get { return filter.valueForKey(kCIInputRadiusKey) as! Double }
//    set { filterForWriting.setValue(newValue, forKey: kCIInputRadiusKey)  }
//  }
//  
//}
//
//extension GaussianBlur {
//  var outputImage: CIImage {
//    return filter.outputImage!
//  }
//}

final class Box<A> {
  var unbox: A
  init(_ value: A){ unbox = value }
}

struct GaussianBlur {
  private var boxedFilter: Box<CIFilter> = {
    var filter = CIFilter(name: "CIGaussianBlur", withInputParameters: [:])!
    return Box(filter)
  }()
  
  var filter: CIFilter {
    get { return boxedFilter.unbox }
    set { boxedFilter = Box(newValue) }
  }
}

extension GaussianBlur {
  private var filterForWriting: CIFilter {
    mutating get {
      if !isUniquelyReferencedNonObjC(&boxedFilter) {
        filter = filter.copy() as! CIFilter
      }
      return filter
    }
  }
}

extension GaussianBlur {
  var inputImage: CIImage {
    get { return filter.valueForKey(kCIInputImageKey) as! CIImage }
    set { filterForWriting.setValue(newValue, forKey: kCIInputImageKey) }
  }
  
  var radius: Double {
    get { return filter.valueForKey(kCIInputRadiusKey) as! Double }
    set { filterForWriting.setValue(newValue, forKey: kCIInputRadiusKey)  }
  }
  
}

extension GaussianBlur {
  var outputImage: CIImage {
    return filter.outputImage!
  }
}


