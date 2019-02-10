//
//  Global.swift
//  Final
//
//  Created by Zak Peters on 4/18/17.
//  Copyright © 2017 Zak. All rights reserved.
//

import Foundation
import GLKit
import UIKit

struct Global {
    // generic vars
    static var aspect : Float = 1.0
    static let context = EAGLContext(api: .openGLES2)
    static var width : Float = 1.0
    static var height : Float = 1.0
    
    // variables for resuming games
    static var game : SpriteViewController = SpriteViewController()
    static var playing : Bool = false
    
    static func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        
        
        image.draw(in: CGRect(x: 0, y: 0,width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
