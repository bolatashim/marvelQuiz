//
//  ViewController.swift
//  API-Sandbox
//
//  Created by Dion Larson on 6/24/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage
import AlamofireNetworkActivityIndicator
import CryptoSwift

class ViewController: UIViewController {
    var dataForAllChars : [JSON] = []
    var theCorrectOption = 0
    var optionChars : [marvelChar!] = []
    var correctGuesses: Int = 0
    var totalAttempts: Int = 0
    var optionsPressedBools = [false, false, false]
    
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    @IBOutlet weak var buttonThree: UIButton!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var playerScore: UILabel!
    @IBOutlet weak var ScoreWindowAtTheEnd: UILabel!
    
    @IBAction func optionOnePressed(button: AnyObject) {
        if !optionsPressedBools[2] && !optionsPressedBools[1] && !optionsPressedBools[0]{
            colorAndSwitch(0)
        }
    }
    
    @IBAction func optionTwoPressed(button: UIButton) {
        if !optionsPressedBools[2] && !optionsPressedBools[1] && !optionsPressedBools[0]{
            colorAndSwitch(1)
        }
    }
    
    @IBAction func optionThreePressed(sender: AnyObject) {
        if !optionsPressedBools[2] && !optionsPressedBools[1] && !optionsPressedBools[0]{
            colorAndSwitch(2)
        }
    }
    
    
    func colorAndSwitch(selectedOption: Int){
        colorUpEverything(selectedOption)
        optionsPressedBools[selectedOption] = true
        let priority = DISPATCH_QUEUE_PRIORITY_LOW
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            sleep(1)
            dispatch_async(dispatch_get_main_queue(), {
                self.resetAlltheStuff(selectedOption)
            })
        }
    }
    
    
    func colorUpEverything(option: Int){
        var buttonsArray = [buttonOne, buttonTwo, buttonThree]
        if option == theCorrectOption{
            buttonsArray[option].backgroundColor = UIColor(red:0.15, green: 0.80, blue: 0.43, alpha: 1.0)
            totalAttempts += 1
            correctGuesses += 1
        }else{
            buttonsArray[option].setTitleColor(UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), forState: .Normal)
            buttonsArray[option].backgroundColor = UIColor(red:1.0, green: 0.0, blue: 0.01, alpha: 1.0)
            buttonsArray[theCorrectOption].backgroundColor = UIColor(red:0.15, green: 0.80, blue: 0.43, alpha: 1.0)
            totalAttempts += 1
        }
        playerScore.text = "Score: \(correctGuesses) / \(totalAttempts)"
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overView = UIView(frame: UIScreen.mainScreen().applicationFrame)
        overView!.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
       // let imagey : UIImage = UIImage(named: "image-quiz")!
        
        
        //self.overView?.
        //self.overView?.addSubview(UIImage(named: "quiz-image"))
        self.view.addSubview(overView!)

        
        let publicKey = "fc895756a4ff48c8c39c5270ed79a06d"
        let privateKey = "527d262aefaa6d31f899858ed432c60a65f52538"
        let timeStamp = arc4random_uniform(20)
        let hash = "\(timeStamp)\(privateKey)\(publicKey)".md5()
        let apiToContact = "http://gateway.marvel.com/v1/public/characters?ts=\(timeStamp)&apikey=\(publicKey)&hash=\(hash)&limit=100"
        
        Alamofire.request(.GET, apiToContact).validate().responseJSON() { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    
                    let allData = json["data"]["results"].arrayValue
                    for i in allData{
                        if marvelChar(json: i).imageExists{
                            self.dataForAllChars.append(i)
                        }
                    }
                    
                }
                print(apiToContact)
            case .Failure(let error):
                print(error)
            }
            self.generateRandomCharacters()
            self.overView?.alpha = 0
            self.self.view!.sendSubviewToBack(self.overView!)
            
        }
    }
    
    var overView: UIView?
    
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadPoster(urlString: String){
        characterImageView.af_setImageWithURL(NSURL(string: urlString)!)
    }
    
    func resetAlltheStuff(optionSelected: Int){
        let buttonsArray = [buttonOne, buttonTwo, buttonThree]
        buttonsArray[optionSelected].selected = false

        if totalAttempts < 10{
            let buttonsArray = [buttonOne, buttonTwo, buttonThree]
            for button in buttonsArray{
                button.backgroundColor = UIColor(red:0.827, green: 0.827, blue: 0.827, alpha: 1.0)
                button.setTitleColor(UIColor(red:1.0, green: 0.0, blue: 0.01, alpha: 1.0), forState: .Normal)
            }
            optionsPressedBools[optionSelected] = false
            generateRandomCharacters()
        }else{
            ScoreWindowAtTheEnd.backgroundColor = UIColor.whiteColor()
            ScoreWindowAtTheEnd.text = "You Got \(correctGuesses) out of \(totalAttempts) correct"
        }

    }
    
    func generateRandomCharacters(){
        let arrayLength = UInt32(dataForAllChars.count)
        let rand1 = Int(arc4random_uniform(arrayLength))
        var rand2 = Int(arc4random_uniform(arrayLength))
        var rand3 = Int(arc4random_uniform(arrayLength))
        while (rand2 == rand1) {
            rand2 = Int(arc4random_uniform(arrayLength))
        }
        while (rand3 == rand2 || rand3 == rand1) {
            rand3 = Int(arc4random_uniform(arrayLength))
        }
        optionChars = [marvelChar(json:dataForAllChars[rand1]), marvelChar(json:dataForAllChars[rand2]), marvelChar(json:dataForAllChars[rand3])]
        
        //this is to remove the chars I already showed
        dataForAllChars.removeAtIndex(rand1)
        if rand2 == 0{
            dataForAllChars.removeAtIndex(rand2)

        }else if rand2 > rand1{
            dataForAllChars.removeAtIndex(rand2 - 1)
        }else{
            dataForAllChars.removeAtIndex(rand2)
        }
        
        if rand3 == 0 || (rand3 < rand2 && rand3 < rand1){
            dataForAllChars.removeAtIndex(rand3)
        }else if (rand3 > rand2 && rand3 > rand1){
            dataForAllChars.removeAtIndex(rand3 - 2)
        }else{
            dataForAllChars.removeAtIndex(rand3 - 1)
        }
        
        
        
        let correctOption = Int(arc4random_uniform(3))
        
        loadPoster(optionChars[correctOption].imageLink)
        theCorrectOption = correctOption

        buttonOne.setTitle(optionChars[0].name, forState: .Normal)
        buttonTwo.setTitle(optionChars[1].name, forState: .Normal)
        buttonThree.setTitle(optionChars[2].name, forState: .Normal)
    }
}















