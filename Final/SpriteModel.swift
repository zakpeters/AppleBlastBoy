//
//  SpriteModel.swift
//  Final
//
//  Created by Zak Peters on 4/17/17.
//  Copyright © 2017 Zak. All rights reserved.
//

import UIKit

class SpriteModel{
    //position and collisiont
    var posX : Float = 0.0
    var posY : Float = 0.0
    var radius : Float = 0.0
    
    //variables for enemies
    var lives : Int = 3
    var points : Int = 100
    var type : String = ""
    var xVelocity : Float = 0.0
    var yVelocity : Float = 0.0
    var visible  = true
    var targetX : Float = 0.1
    var targetY : Float = 0.1
    var yScale : Float = 0.0
    var xScale : Float = 0.0
    
    
    var rotate : Float = 0.0 //rotation
    
    
    var sprite : Sprite
    
    // todo add images to constructor
    init(rad : Float, img : UIImage) {
        let image = Global.resizeImage(image: img, newWidth: CGFloat(rad))
        sprite = Sprite(image: image)
        sprite.scaleX = 1 / Global.width * rad
        sprite.scaleY = 1 / Global.height * rad
        yScale = sprite.scaleY
        xScale = sprite.scaleX
        radius = sprite.scaleX / 2.3
    }
    
    // todo add velocity characteristics
    func update() {
        if type == "zigzag" || type == "random"{
            if posX <= -0.85{
                if xVelocity < 0.0{
                    xVelocity = -xVelocity
                    sprite.scaleX = -sprite.scaleX
                }
            }
            if posX >= 0.85{
                if xVelocity > 0.0{
                    xVelocity = -xVelocity
                    sprite.scaleX = -sprite.scaleX
                }
            }
            
        }
        if type == "random"{
            var r = arc4random_uniform(30)
            if r == 0{
                //random y velocity
                let v = arc4random_uniform(10) + 1
                yVelocity = -0.002 * Float(v)
            }
            r = arc4random_uniform(30)
            if r == 0{
                let x = arc4random_uniform(10)
                xVelocity = 0.002 * (Float(x)-5.0)
                
            }
        }
        if type == "charger"{
            let magnitude = pow(pow((posX - targetX), 2) + pow((posY - targetY), 2), 0.5)
            if magnitude > 0.1{
                xVelocity = (posX - targetX) / magnitude * -0.05
                
                let p = posX + xVelocity
                if p > -1 && p < 1 {
                    posX = p
                    sprite.rotation = xVelocity * -10
                }
                
            }
            posY += yVelocity
        }
        
        else if type == "target" {
            let magnitude = pow(pow((posX - targetX), 2) + pow((posY - targetY), 2), 0.5)
            if magnitude > 0.1{
                    xVelocity = (posX - targetX) / magnitude * -0.04
                    yVelocity = (posY - targetY) / magnitude * -0.04
                
                let p = posX + xVelocity
                if p > -1 && p < 1 {
                    posX = p
                    sprite.rotation = xVelocity * -10
                }
                let o = posY + yVelocity
                if o > -1 && o < -0.4{
                    posY = o
                    sprite.scaleY = yScale * (yVelocity * 4 + 1.0)
                    sprite.scaleX = xScale * (-yVelocity * 4 + 1.0)
                }
            }else{
                sprite.rotation = 0.0
                sprite.scaleY = yScale
                sprite.scaleX = xScale
            }
        }
        else{
            posX += xVelocity
            posY += yVelocity
        }
        
        sprite.rotation += rotate
        sprite.positionX = posX
        sprite.positionY = posY
    }
}
