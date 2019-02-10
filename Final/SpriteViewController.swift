//
//  ViewController.swift
//  Final
//
//  Created by Zak Peters on 4/10/17.
//  Copyright © 2017 Zak. All rights reserved.
//

import GLKit

class SpriteViewController: GLKViewController {
    
    private var time: Float = 0
    private var prefferedFramesPerSecond : Int = 30
    private var translateX: Float = 0
    private var translateY: Float = 0
    
    private var program: GLuint = 0
    private var texture: GLKTextureInfo? = nil
    
    private var aspect : Float!
    
    private var world : WorldModel!
    private var back1: Sprite!
    private var back2: Sprite!
    
    // Buttons
    //    private var left: UIButton!
    //    private var right: UIButton!
    //    private var up: UIButton!
    //    private var down: UIButton!
    private var blackout: UIButton!
    private var apple : UIButton!
    
    // Labels
    private var scorelabel: UILabel!
    private var livelabel: UILabel!
    private var levellabel: UILabel!
    private var game: UILabel!
    private var over: UILabel!
    
    
    
    
    // Direction player is currently moving
    var dir = 0
    private var lvl = 1
    
    func background(image : UIImage){
        let img : UIImage = Global.resizeImage(image: image, newWidth: CGFloat(Global.width)*2.05)
        
        back1 = Sprite(image: img)
        back2 = Sprite(image: img)
        
        back1.scaleX = 2
        back1.scaleY = 2
        back2.scaleX = 2
        back2.scaleY = 2
        
        back1.positionX = 0.0
        back2.positionX = 0.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Global.aspect = Float(self.view.bounds.width/self.view.bounds.height)
        glkView.context = Global.context!
        EAGLContext.setCurrent(glkView.context)
        
        glEnable(GLenum(GL_BLEND))
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))
        
        world = WorldModel()
        isPaused = true
        background(image : #imageLiteral(resourceName: "circuit"))
        
        //        //base UI
        //        let w = self.view.bounds.width / 4.5
        //
        //        left = UIButton(frame: CGRect(x: 0.0, y: self.view.bounds.height - w, width: w, height: w))
        //
        //        left.setImage(#imageLiteral(resourceName: "leftbutton"), for: UIControlState.normal)
        //        left.addTarget(self, action: #selector(leftB), for: .touchDown)
        //        left.addTarget(self, action: #selector(releaseB), for: .touchUpInside)
        ////        self.view.addSubview(left)
        //
        //        up = UIButton(frame: CGRect(x: 0.0, y: self.view.bounds.height - w - w - 10.0, width: w, height: w))
        //
        //        up.setImage(#imageLiteral(resourceName: "upbutton"), for: UIControlState.normal)
        //        up.addTarget(self, action: #selector(upB), for: .touchDown)
        //        up.addTarget(self, action: #selector(releaseB), for: [.touchUpInside, .touchUpOutside])
        ////        self.view.addSubview(up)
        //
        //        right = UIButton(frame: CGRect(x: self.view.bounds.width - w,y: self.view.bounds.height - w, width: w, height: w))
        //
        //        right.setImage(#imageLiteral(resourceName: "rightbutton"), for: UIControlState.normal)
        //        right.addTarget(self, action: #selector(rightB), for: .touchDown)
        //        right.addTarget(self, action: #selector(releaseB), for: .touchUpInside)
        ////        self.view.addSubview(right)
        //
        //        down = UIButton(frame: CGRect(x: self.view.bounds.width - w,y: self.view.bounds.height - w - w - 10.0, width: w, height: w))
        //
        //        down.setImage(#imageLiteral(resourceName: "downbutton"), for: UIControlState.normal)
        //        down.addTarget(self, action: #selector(downB), for: .touchDown)
        //        down.addTarget(self, action: #selector(releaseB), for: .touchUpInside)
        //        down.alpha = 0.5
        ////        self.view.addSubview(down)
        
        scorelabel = UILabel(frame: CGRect(x: self.view.bounds.width / 2.0, y: 0.0, width : self.view.bounds.width * 0.45, height : self.view.bounds.height / 10.0))
        
        scorelabel.textAlignment = NSTextAlignment.right
        scorelabel.textColor = UIColor.white
        scorelabel.font = scorelabel.font.withSize(24)
        self.view.addSubview(scorelabel)
        
        livelabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width : self.view.bounds.width * 0.8, height : self.view.bounds.height / 10.0))
        livelabel.text = "  Lives: O O O O O"
        livelabel.textAlignment = NSTextAlignment.left
        livelabel.textColor = UIColor.white
        livelabel.font = livelabel.font.withSize(24)
        self.view.addSubview(livelabel)
        
        levellabel = UILabel(frame: CGRect(x: 0.0, y: self.view.bounds.height / 2.5, width : self.view.bounds.width, height : self.view.bounds.height / 10.0))
        levellabel.text = "Level \(lvl - 1) Completed"
        levellabel.textAlignment = NSTextAlignment.center
        levellabel.textColor = UIColor.white
        levellabel.font = levellabel.font.withSize(24)
        levellabel.isHidden = true
        self.view.addSubview(levellabel)
        
        blackout = UIButton(frame: CGRect(x: 0.0,y: 0.0, width: self.view.bounds.width, height: self.view.bounds.height))
        blackout.backgroundColor = UIColor.black
        blackout.alpha = 0.0
        self.view.addSubview(blackout)
        
        let z = self.view.bounds.width / 6
        apple = UIButton(frame: CGRect(x: (self.view.bounds.width - z) / 2, y: (self.view.bounds.height  - z) / 2, width: z, height: z))
        apple.alpha = 0.0
        apple.setImage(#imageLiteral(resourceName: "apple-logo-white-md"), for: UIControlState.normal)
        self.view.addSubview(apple)
        
        game = UILabel(frame: CGRect(x: 0.0, y: self.view.bounds.height / 3, width : self.view.bounds.width, height : self.view.bounds.height / 10.0))
        game.text = "GAME"
        game.textColor = UIColor.white
        game.font = game.font.withSize(40)
        game.alpha = 0.0
        game.textAlignment = NSTextAlignment.center
        self.view.addSubview(game)
        
        over = UILabel(frame: CGRect(x: 0.0, y: self.view.bounds.height / 6 * 3.5, width : self.view.bounds.width, height : self.view.bounds.height / 10.0))
        over.text = "OVER"
        over.textColor = UIColor.white
        over.font = game.font
        over.alpha = 0.0
        over.textAlignment = NSTextAlignment.center
        self.view.addSubview(over)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        if Global.playing == false{
            Global.playing = true
            alert_me(title: "Welcome to Apple Blast Boy", msg: "You play as Steve Jobs in the quest for Apple dominance.\nControls:\nTouch anywhere to shoot. Touch and drag in the lower half of the screen to move.\n\nWinDopes Incoming.\n(Predictable and Slow)")
        }else{
            alert_me(title: "Exiting Sleep Mode", msg: "Press OK to resume.")
        }
    }
    override func glkView(_ view: GLKView, drawIn rect: CGRect){
        glClearColor(0.0, 0.0, 0.0, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
    
        translateY -= 0.01
        
        //wrap around
        if translateY <= 0.0{
            translateY = 2.0
        }
        back1.positionY = translateY
        back2.positionY = translateY - 2.0
                        back1.draw()
                        back2.draw()
        
        for x in world.p_proj{
            let s = x as? SpriteModel
            s?.sprite.draw()
        }
        for x in world.e_proj{
            let s = x as? SpriteModel
            s?.sprite.draw()
        }
        for x in world.enemies{
            let s = x as? SpriteModel
            s?.sprite.draw()
        }
        for x in world.explodes{
            let s = x as? SpriteModel
            s?.sprite.draw()
        }
        
        if world.player.visible{
            world.player.sprite.draw()
        }
        
    }
    
    func update() {
        
        time += 0.001
        
        world.update_loop()
        
        //score stuff
        scorelabel.text = String(world.score)
        
        //construct live label
        var s : String = " Lives:"
        for i in 0...4{
            if world.playerLives > i{
                s += " O"
            }else{
                s += " X"
            }
        }
        livelabel.text = s
        
        if(world.delay <= -15){
            levellabel.isHidden = true
        }
        
        if world.level > lvl{
            lvl = world.level
            if lvl == 2 {
                alert_me(title: "Victory! (+1000 points)", msg: "You defeated the WinDopes!!!\nThe FanDroids are coming\n(Fast but Fragile)")
                background(image: #imageLiteral(resourceName: "wallpaper-android-hd-1"))
            }else if lvl == 3{
                alert_me(title: "Victory! (+2000 points)", msg: "That OS is DoA!\nWait...\nJailbreakers???\nThey're poisoning our Apple!!!\n(Buggy and Volatile)")
                background(image : #imageLiteral(resourceName: "Matrix-Binary-iphone-4s-wallpaper-ilikewallpaper_com"))
            }else if lvl == 4{
                alert_me(title: "Victory! (+3000 points)", msg: "You slayed those hacks!!!\nNow just keep it up!\nSurvival Mode: Enemy spawn rate will increase with each level")
                background(image : #imageLiteral(resourceName: "8cf3d5923daa53ef9cda0bbc7186917e"))
            }else{
                levellabel.text = "Level \(lvl - 1) Completed"
                levellabel.isHidden = false
                
            }
        }
        
        if world.playerLives <= 0{
            // disable resume
            Global.playing = false
            UIView.animate(withDuration: 2.5, animations: {
                self.blackout.alpha = 1.0
                self.apple.alpha = 1.0
                self.game.alpha = 1.0
                self.over.alpha = 1.0
            }, completion: {
                (finished : Bool) in
                if finished {
                    sleep(3)
//                    self.alert_me(title: "Game Over!", msg: "Better luck next time.")
                    let storyboard = UIStoryboard(name: "MainMenu", bundle: nil)
                    let h = storyboard.instantiateViewController(withIdentifier: "HighScore") as! HighScoreViewController
                    
                    h.s = self.world.score
                    self.present(h, animated: true, completion: nil)
                }
            })
        }
    }
    
    
    private var glkView: GLKView {
        return view as! GLKView
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        let touchPoint: CGPoint = touch.location(in: self.view)
        
        if touchPoint.y > self.view.bounds.height / 2 {
            let touchX = (Float(touchPoint.x) / Global.width * 2 - 1.0 )
            let touchY = -(Float(touchPoint.y) / Global.height * 2 - 1.0)
            world.player.targetX = touchX
            world.player.targetY = touchY
        }
        world.fire = true
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        let touchPoint: CGPoint = touch.location(in: self.view)
        
        if touchPoint.y > self.view.bounds.height * 2 / 3 {
            let touchX = (Float(touchPoint.x) / Global.width * 2 - 1.0 )
            let touchY = -(Float(touchPoint.y) / Global.height * 2 - 1.0)
//            print(touchX)
//            print(touchY)
            world.player.targetX = touchX
            world.player.targetY = touchY
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        releaseB()
        world.player.targetX = world.player.posX
        world.player.targetY = world.player.posY
        world.fire = false
    }
    //    func upB(){
    //        up.setImage(#imageLiteral(resourceName: "upbutton2"), for: UIControlState.normal)
    //        world.dir = 2
    //    }
    //    func downB(){
    //        down.setImage(#imageLiteral(resourceName: "downbutton2"), for: UIControlState.normal)
    //        world.dir = 1
    //    }
    //    func leftB(){
    //        left.setImage(#imageLiteral(resourceName: "leftbutton2"), for: UIControlState.normal)
    //        world.dir = -2
    //    }
    //    func rightB(){
    //        right.setImage(#imageLiteral(resourceName: "rightbutton2"), for: UIControlState.normal)
    //        world.dir = -1
    //    }
    //
    //    func releaseB(){
    //        // TODO revisit this
    //        world.dir = 0
    //        up.setImage(#imageLiteral(resourceName: "upbutton"), for: UIControlState.normal)
    //        down.setImage(#imageLiteral(resourceName: "downbutton"), for: UIControlState.normal)
    //        left.setImage(#imageLiteral(resourceName: "leftbutton"), for: UIControlState.normal)
    //        right.setImage(#imageLiteral(resourceName: "rightbutton"), for: UIControlState.normal)
    //    }
    
    func alert_me(title : String, msg : String){
        isPaused = true
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: resume))
        self.present(alert, animated: true)
    }
    
    func resume(alert: UIAlertAction){
        if Global.playing == true{
            isPaused = false
        }else{
            let storyboard = UIStoryboard(name: "MainMenu", bundle: nil)
            let h = storyboard.instantiateViewController(withIdentifier: "HighScore") as! HighScoreViewController
            
            h.s = world.score
            self.present(h, animated: true, completion: nil)
        }
    }
}
