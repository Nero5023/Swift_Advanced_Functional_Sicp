//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

typealias Filter = CIImage -> CIImage


func blur(radius: Double) -> Filter {
  return { image in
    let parameters = [
      kCIInputRadiusKey: radius,
      kCIInputImageKey: image
    ]
    guard let filter = CIFilter(name: "CIGaussianBlur", withInputParameters: parameters) else
    { fatalError() }
    guard let outputImage = filter.outputImage else { fatalError() }
    return outputImage
  }
}

func colorGenerator(color: NSColor) -> Filter {
  return { _ in
    guard let c = CIColor(color: color) else { fatalError() }
    let parameters = [kCIInputColorKey: c]
    guard let filter = CIFilter(name: "CIConstantColorGenerator", withInputParameters: parameters) else { fatalError() }
    guard let outputImage = filter.outputImage else { fatalError() }
    return outputImage
  }
}

func compositeSoucreOver(overlay: CIImage) -> Filter {
  return { image in
    let parameters = [
      kCIInputBackgroundImageKey: image,
      kCIInputImageKey: overlay
    ]
    guard let filter = CIFilter(name: "CISourceOverCompositing", withInputParameters: parameters) else { fatalError() }
    guard let outputImage = filter.outputImage else { fatalError() }
    let cropRect = image.extent
    return outputImage.imageByCroppingToRect(cropRect)
  }
}

func colorOVerlay(color: NSColor) -> Filter {
  return { image in
    let overlay = colorGenerator(color)(image)
    return compositeSoucreOver(overlay)(image)
  }
}

let url = NSURL(string: "https://www.objc.io/images/covers/16.jpg")!
//let image = CIImage(contentsOfURL: url)!
//
let blurRadius = 5.0
let overlayColor = NSColor.redColor().colorWithAlphaComponent(0.2)
//let blurredimage = blur(blurRadius)(image)
//let overlaidImage = colorOVerlay(overlayColor)(blurredimage)

func composeFilters(filter1: Filter, _ filter2: Filter) -> Filter {
  return { image in filter2(filter1(image)) }
}

//let myFilter1 = composeFilters(blur(blurRadius), colorOVerlay(overlayColor))
//let result1 = myFilter1(image)

infix operator >>> { associativity left }

func >>>(filter1: Filter, filter2: Filter) -> Filter {
  return { image in filter2(filter1(image)) }
}

//func add3(x: Int)(_ y: Int) -> Int {
//  return x + y
//}
//
