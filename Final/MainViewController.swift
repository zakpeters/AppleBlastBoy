//
//  MainViewController.swift
//  Final
//
//  Created by Zak Peters on 4/18/17.
//  Copyright © 2017 Zak. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var Resume: UIButton!
    
    @IBAction func newgame(_ sender: Any) {
        Global.game = SpriteViewController()
        self.present(Global.game, animated: true, completion: nil)
        
    }
    @IBAction func resumeGame(_ sender: Any) {
        self.present(Global.game, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Global.width = Float(self.view.bounds.width)
        Global.height = Float(self.view.bounds.height)
        Global.aspect = Global.width / Global.height
        if Global.playing{
            Resume.isEnabled = true
        }else{
            Resume.tintColor = UIColor.white
            Resume.isEnabled = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
