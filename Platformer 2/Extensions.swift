//
//  Extensions.swift
//  Platformer 2
//
//  Created by Lucas Popp on 12/27/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import SpriteKit

public extension String {
    
    var length: Int {
        get {
            return characters.count
        }
    }
    
    func substring(from: Int, to: Int) -> String {
        return substring(with: index(startIndex, offsetBy: from) ..< index(startIndex, offsetBy: to))
    }
    
    func substring(from: Int) -> String {
        return substring(from: from, to: length)
    }
    
    func substring(to: Int) -> String {
        return substring(from: 0, to: to)
    }
    
    func substring(start: Int, length: Int) -> String {
        return substring(from: start, to: start + length)
    }
    
    func characterAt(index: Int) -> String {
        return substring(start: index, length: 1)
    }
    
    func indexOf(string: String) -> Int {
        for i in 0 ..< self.length - string.length {
            if self.substring(start: i, length: string.length) == string {
                return i
            }
        }
        
        return -1
    }
    
}

public extension UIImage {
    
    func colorOfPixel(x: Int, y: Int) -> UIColor? {
        let scaledX: CGFloat = CGFloat(x) * scale
        let scaledY: CGFloat = CGFloat(y) * scale
        
        if let cg: CGImage = cgImage {
            if let provider: CGDataProvider = cg.dataProvider {
                if let pixelData: CFData = provider.data {
                    let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
                    
                    let pixelInfo: Int = Int(((size.width * scaledY * scale) + scaledX) * 4)
                    
                    let r = CGFloat(data[pixelInfo]) / 255.0
                    let g = CGFloat(data[pixelInfo + 1]) / 255.0
                    let b = CGFloat(data[pixelInfo + 2]) / 255.0
                    let a = CGFloat(data[pixelInfo + 3]) / 255.0
                    
                    return UIColor(red: r, green: g, blue: b, alpha: a)
                }
            }
        }
        
        return nil
    }
    
    func withRainbow(offsetBy offset: CGFloat) -> UIImage? {
        if let cg: CGImage = cgImage {
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            let context = UIGraphicsGetCurrentContext()
            
            draw(at: CGPoint.zero)
            
            if let provider: CGDataProvider = cg.dataProvider {
                if let pixelData: CFData = provider.data {
                    let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
                    
                    for col in 0 ..< Int(size.width) {
                        for row in 0 ..< Int(size.height) {
                            let scaledX: CGFloat = CGFloat(col) * scale
                            let scaledY: CGFloat = CGFloat(row) * scale
                            
                            let pixelInfo: Int = Int(((size.width * scaledY * scale) + scaledX) * 4)
                            
                            let r = CGFloat(data[pixelInfo]) / 255.0
                            let g = CGFloat(data[pixelInfo + 1]) / 255.0
                            let b = CGFloat(data[pixelInfo + 2]) / 255.0
                            let a = CGFloat(data[pixelInfo + 3]) / 255.0
                            
                            let lightness: CGFloat = (min(r, g, b) + max(r, g, b)) / 2
                            
                            let baseH: CGFloat = (CGFloat(col) / size.width) * (CGFloat(row) / size.height)
                            
                            let h: CGFloat = (baseH + offset) > 1 ? (offset + baseH - 1) : (baseH + offset)
                            
                            context?.setFillColor(UIColor(hue: h, saturation: 1, brightness: 1, alpha: 0.5 * a * lightness).cgColor)
                            context?.fill(CGRect(x: col, y: row, width: 1, height: 1))
                        }
                    }
                }
            }
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        
        return nil
    }
    
}

// MARK: CGPoint and CGPoint

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func += (left: inout CGPoint, right: CGPoint) {
    left.x += right.x
    left.y += right.y
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func -= (left: inout CGPoint, right: CGPoint) {
    left.x -= right.x
    left.y -= right.y
}

func * (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x * right.x, y: left.y * right.y)
}

func *= (left: inout CGPoint, right: CGPoint) {
    left.x *= right.x
    left.y *= right.y
}

func / (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x / right.x, y: left.y / right.y)
}

func /= (left: inout CGPoint, right: CGPoint) {
    left.x /= right.x
    left.y /= right.y
}

// MARK: CGPoint and CGFloat

func * (left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x * right, y: left.y * right)
}

func *= (left: inout CGPoint, right: CGFloat) {
    left.x *= right
    left.y *= right
}

func / (left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x / right, y: left.y / right)
}

func /= (left: inout CGPoint, right: CGFloat) {
    left.x /= right
    left.y /= right
}

// MARK: CGSize and CGSize

func + (left: CGSize, right: CGSize) -> CGSize {
    return CGSize(width: left.width + right.width, height: left.height + right.height)
}

func += (left: inout CGSize, right: CGSize) {
    left.width += right.width
    left.height += right.height
}

func - (left: CGSize, right: CGSize) -> CGSize {
    return CGSize(width: left.width - right.width, height: left.height - right.height)
}

func -= (left: inout CGSize, right: CGSize) {
    left.width -= right.width
    left.height -= right.height
}

func * (left: CGSize, right: CGSize) -> CGSize {
    return CGSize(width: left.width * right.width, height: left.height * right.height)
}

func *= (left: inout CGSize, right: CGSize) {
    left.width *= right.width
    left.height *= right.height
}

func / (left: CGSize, right: CGSize) -> CGSize {
    return CGSize(width: left.width / right.width, height: left.height / right.height)
}

func /= (left: inout CGSize, right: CGSize) {
    left.width /= right.width
    left.height /= right.height
}

// Restrict a CGFloat to a range
func bind(_ value: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
    return value < min ? min : value < max ? value : max
}

func round(_ value: CGFloat, places: Int) -> CGFloat {
    return round(value * pow(10, CGFloat(places))) / pow(10, CGFloat(places))
}

// CGPoint

extension CGPoint {
    
    static func distanceBetween(_ point1: CGPoint, and point2: CGPoint) -> CGFloat {
        return sqrt(pow(point1.x - point2.x, 2) + pow(point1.y - point2.y, 2))
    }
    
}
