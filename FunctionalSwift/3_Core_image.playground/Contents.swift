//: Playground - noun: a place where people can play

import UIKit

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



