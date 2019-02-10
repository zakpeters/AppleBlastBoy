//
//  HighScoreView.swift
//  Final
//
//  Created by Zak Peters on 4/18/17.
//  Copyright © 2017 Zak. All rights reserved.
//

import UIKit

class HighScoreViewController: UIViewController {
    
    //names
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
   
    //scores
    @IBOutlet weak var lab1: UILabel!
    @IBOutlet weak var lab2: UILabel!
    @IBOutlet weak var lab3: UILabel!
    @IBOutlet weak var lab4: UILabel!
    @IBOutlet weak var lab5: UILabel!
    
    
     var hs : HighScore!
    var s = -1 //score for new entry
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let userDefaults = UserDefaults.standard
        let any = userDefaults.object(forKey: "highscore") as? NSData
        
        if let any = any{
            hs = NSKeyedUnarchiver.unarchiveObject(with: any as Data) as? HighScore
        }else{
            hs = HighScore()
            //create some high scores if they don't exist yet
            hs.addScore(name: "STEVE", score: 500)
            hs.addScore(name: "JOBS", score: 400)
            hs.addScore(name: "WAS", score: 300)
            hs.addScore(name: "HERE", score: 200)
            hs.addScore(name: "ONCE", score: 100)
            saveScores()
        }
        updateScores()
    }
    
    func updateScores() {
//        label1.text = hs.getString(at: 0)
//        label2.text = hs.getString(at: 1)
//        label3.text = hs.getString(at: 2)
//        label4.text = hs.getString(at: 3)
//        label5.text = hs.getString(at: 4)
        label1.text = hs.names[0]
        label2.text = hs.names[1]
        label3.text = hs.names[2]
        label4.text = hs.names[3]
        label5.text = hs.names[4]
        lab1.text = String(hs.scores[0])
        lab2.text = String(hs.scores[1])
        lab3.text = String(hs.scores[2])
        lab4.text = String(hs.scores[3])
        lab5.text = String(hs.scores[4])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (hs.scores.count < 5 || s > hs.scores[4]) && s != -1 {
            presentAlert()
        }
        
        updateScores()
    }
    
    func presentAlert() {
        let alertController = UIAlertController(title: "You got a High Score of \(s)!", message: "Input your name:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                if field.text! == ""{
                    self.hs.addScore(name: "??????", score: self.s)
                }
                else{
                    self.hs.addScore(name: field.text!, score: self.s)
                }
                self.saveScores()
                self.s = -1
                self.updateScores()
            } else {
                self.hs.addScore(name: "?????", score: self.s)
                self.saveScores()
                self.s = -1
                self.updateScores()
            }
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = ""
        }
        
        alertController.addAction(confirmAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    func saveScores(){
        let userDefaults = UserDefaults.standard
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: hs)
        userDefaults.set(encodedData, forKey:"highscore")
        userDefaults.synchronize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
