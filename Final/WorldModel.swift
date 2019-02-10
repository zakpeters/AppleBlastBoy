//
//  WorldModel.swift
//  Final
//
//  Created by Zak Peters on 4/17/17.
//  Copyright © 2017 Zak. All rights reserved.
//

import Foundation

class WorldModel{
    // objects
    var player : SpriteModel// = SpriteModel()
    var enemies : NSMutableArray = []
    var p_proj : NSMutableArray = []
    var e_proj : NSMutableArray = []
    var explodes : NSMutableArray = []
    
    // is firing and timer to determine if can fire again
    var fire : Bool = false
    var lastfire = Date()
    var rot = false //alternate rotation of player projectiles
    
//    var dir = 0 //variable for player movement
    var aspect : Float = 1.0
    var score = 0
    var playerLives = 5
    var level = 1
    var enemies_level = 0
    var delay = 60
   
    
    // for random generation increases likelihood if enemy hasn't been spawned
    var randFactor : UInt32 = 100
    
    var invuln = Date()
    
    var vis_count = 0
    let proj_rate : Float = 0.05
    
    var e_rate = 120
    
    
    init() {
//        dir = 0
        vis_count += 1
        aspect = Global.aspect
        player = SpriteModel(rad: 150.0, img: #imageLiteral(resourceName: "jobs-emblem"))
        player.radius *= 0.65
        player.posX = 0.0
        player.posY = -0.75
        player.targetX = 0.0
        player.targetY = -0.75
        player.type = "target"
    }
    
    func update_loop(){
        delay -= 1
        
        if enemies_level < 25 {
            if delay <= 0{
                add_enemies()
            }
            
        }else if enemies.count == 0 && e_proj.count == 0{
            enemies_level = 0
            score += 1000 * level
            level += 1
            delay = 60
            print(level)
        }
        
        enemyfire()
        projectile_update()
        collision_update()
        cleanup()
        if playerLives == 0{
            let exp = SpriteModel(rad: 150.0, img: #imageLiteral(resourceName: "vkrzngmkalmwmkodpgmn"))
            exp.lives = 30
            exp.posY = player.posY
            exp.posX = player.posX
            explodes.add(exp)
        }
    }
    
    func add_enemies(){
        
        //add better waves later
        if level != 0{
            // decrement random
            randFactor -= 1
            
            let r = arc4random_uniform(randFactor)
            if r == 0{
                var enemy : SpriteModel
                var e = level
                
                if level > 3 {
                    e = Int(arc4random_uniform(3) + 1)
                }
                if e == 1{
                    enemy = SpriteModel(rad: 120.0, img: #imageLiteral(resourceName: "windows1"))
                    enemy.type = "zigzag"
                    enemy.yVelocity = -0.005
                    enemy.lives = 2
                   
                    if arc4random_uniform(2) != 0{
                        enemy.xVelocity = 0.02
                    }else{
                        enemy.xVelocity = -0.02
                    }
                     enemy.sprite.rotation = enemy.xVelocity / -0.004 * -0.3
                }else if e == 2 {
                    enemy = SpriteModel(rad: 120.0, img: #imageLiteral(resourceName: "android-png-0"))
                    enemy.lives = 1
                    enemy.points = 200
                    enemy.yVelocity = -0.04
                    enemy.type = "charger"
                }else{
                    enemy = SpriteModel(rad: 120.0, img: #imageLiteral(resourceName: "poisonapple"))
                    enemy.points = 300
                    enemy.type = "random"
                }
                
                
                // randomly pick enemy x coords
                let z = arc4random_uniform(80)
                
                enemy.posX = 0.02 * (Float(z)-40.0)
                
                enemy.posY = 1.05
                
                enemies.add(enemy)
                enemies_level += 1
                if level < 20{
                    randFactor = UInt32(100 - 5 * level)
                }
                else{
                    randFactor = 5
                }
            }
        }
    }
    
    // move projectiles along path
    // later move this to sprite model update func maybe
    func projectile_update(){
        if fire == true && lastfire < Date(){
            let p = SpriteModel(rad: 50.0, img: #imageLiteral(resourceName: "2000px-Apple_Computer_Logo_rainbow.svg"))
            p.posX = player.posX
            p.posY = player.posY
            p.yVelocity = proj_rate
            if rot{
                p.rotate = 0.2
                rot = false
            }else{
                p.rotate = -0.2
                rot = true
            }
            
            p.update()
            p_proj.add(p)
            lastfire = Date() + 0.4
            
        }
    }
    
    func collision_update(){
        //check for collsion between enemies and player projectiles
        for x in p_proj{
            let p = x as! SpriteModel
            
            for y in enemies{
                let e = y as! SpriteModel
                if ( pow((p.posX - e.posX), 2) + pow((p.posY - e.posY), 2) <= pow((p.radius + e.radius), 2)){
                    // move projectile off screen for cleanup
                    p.posY = 1.5
                    e.lives -= 1
                    
                    if e.lives <= 0 {
                        score += e.points
                        
                        let exp = SpriteModel(rad: 100.0, img: #imageLiteral(resourceName: "vkrzngmkalmwmkodpgmn"))
                        exp.lives = 30
                        exp.posY = e.posY
                        exp.posX = e.posX
                        explodes.add(exp)
                        e.posY = -1.5
                    }
                    
                    print("enemy hit")
                }
            }
        }
        
        //check for collision between player and enemy projectiles
        for x in e_proj{
            let p = x as! SpriteModel
            
            if ( pow((p.posX - player.posX), 2) + pow((p.posY - player.posY), 2) <= pow((p.radius + player.radius), 2)){
                
                let exp = SpriteModel(rad: 50.0, img: #imageLiteral(resourceName: "vkrzngmkalmwmkodpgmn"))
                exp.lives = 30
                exp.posY = p.posY
                exp.posX = p.posX
                explodes.add(exp)
                
                p.posY = -1.5
                if invuln < Date(){
                    invuln = Date() + 1
                    playerLives -= 1
                    vis_count = 30
                    print("player hit")
                }
                else {
                    print("player was invuln")
                }
                
            }
        }
        
        //check for collision between player and enemy bodies
        for x in enemies{
            let p = x as! SpriteModel
            
            if ( pow((p.posX - player.posX), 2) + pow((p.posY - player.posY), 2) <= pow((p.radius + player.radius), 2)){
                
                let exp = SpriteModel(rad: 80.0, img: #imageLiteral(resourceName: "vkrzngmkalmwmkodpgmn"))
                exp.lives = 30
                exp.posY = p.posY
                exp.posX = p.posX
                explodes.add(exp)
                
                if invuln < Date(){
                    invuln = Date() + 1
                    playerLives -= 1
                    vis_count = 30
                    print("collision with enemy")
                }
                else {
                    print("player was invuln")
                }
                
                // immediately remove enemy on collision without checking lives
                p.posY = -1.5
                
                
            }
        }
    }
    
    // cleanup and update sprite locations
    func cleanup(){
        player.update()
        if vis_count == 30{
            player.visible = false
        }
        else if vis_count == 20{
            player.visible = true
        }
        else if vis_count == 10{
            player.visible = false
        }else if vis_count == 0{
            player.visible = true
        }
        vis_count -= 1
        
        for x in p_proj.reversed() {
            let p = x as! SpriteModel
            p.update()
            if p.posY > 1.02{
                p_proj.removeObject(identicalTo: x)
                //                print("cleaned up player proj")
            }
        }
        for x in e_proj.reversed() {
            let p = x as! SpriteModel
            p.update()
            if p.posY < -1.1{
                e_proj.removeObject(identicalTo: p)
                //                print("cleaned up enemy proj")
            }
        }
        for x in enemies.reversed() {
            let p = x as! SpriteModel
            p.update()
            // trig maybe?
            if p.type != "zigzag"{
                p.sprite.rotation = p.xVelocity / p.yVelocity * -0.3
            }
            
            if p.posY < -1.1{
                enemies.removeObject(identicalTo: p)
                //                print("cleaned up enemy")
            }
        }
        for x in explodes.reversed() {
            let p = x as! SpriteModel
            p.update()
            p.lives -= 1
            if p.lives == 0{
                explodes.removeObject(identicalTo: p)
                //                print("cleaned up explosion")
            }
        }
    }
    
    func enemyfire(){
        for x in enemies{
            let e = x as! SpriteModel
            
            if e.type == "charger"{
                e.targetX = player.posX
                e.targetY = player.posY
            }
                
            else if e.posY < 0.95 {
                if e.type == "zigzag"{
                    e_rate -= 1
                    if e_rate == 0{
                        e_rate = 120
                        let p = SpriteModel(rad: 40.0, img: #imageLiteral(resourceName: "xxWwh"))
                        p.posX = e.posX
                        p.posY = e.posY
                        p.update()
                        p.rotate = 0.3
                        p.yVelocity = -proj_rate / 2.0
                        e_proj.add(p)
                    }
                    
                }
                else{
                    let r = arc4random_uniform(100)
                    if r == 0{
                        let p = SpriteModel(rad: 40.0, img: #imageLiteral(resourceName: "xxWwh"))
                        p.posX = e.posX
                        p.posY = e.posY
                        p.update()
                        p.rotate = 0.3
                        p.yVelocity = -proj_rate / 2.0
                        e_proj.add(p)
                    }
                }
            }
        }
    }
    
//    func movement(){
//        if dir == 1 && player.posY > -0.95 {
//            player.posY -= 0.04
//        }
//        else if dir == 2 && player.posY < -0.55 {
//            player.posY += 0.04
//        }
//        else if dir == -1 && player.posX < 0.8{
//            player.posX += 0.04
//            player.sprite.rotation = -0.3
//        }
//        else if dir == -2 && player.posX > -0.8{
//            player.posX -= 0.04
//            player.sprite.rotation = 0.3
//        }
//        else{
//            player.sprite.rotation = 0.0
//        }
//        
//    }
    
}
