//
//  HighScore.swift
//  Final
//
//  Created by Zak Peters on 4/18/17.
//  Copyright © 2017 Zak. All rights reserved.
//

import Foundation


//data class for high scores
class HighScore : NSObject, NSCoding{
    
    var names : [String]
    var scores : [Int]
    override init() {
        names = []
        scores = []
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(names, forKey: "names")
        aCoder.encode(scores, forKey: "score")
    }
    required init?(coder aDecoder: NSCoder) {
        self.names = aDecoder.decodeObject(forKey: "names") as! [String]
        self.scores = aDecoder.decodeObject(forKey: "score") as! [Int]
    }
    
    func addScore(name: String, score: Int){
        for i in 0...4{
            if i < names.count{
                if scores[i] < score{
                    scores.insert(score, at: i)
                    names.insert(name, at: i)
                    break
                }
            }else{
                scores.append(score)
                names.append(name)
                break
            }
        }
        if names.count > 5{
            names.remove(at: 5)
            
        }
        if scores.count > 5{
            scores.remove(at: 5)
        }
    }
    func getString(at: Int)->String{
        if names.count > at{
            return "\(names[at])\t\(scores[at])"
        }
        else{
            return "ERROR\t1337"
        }
    }
}
