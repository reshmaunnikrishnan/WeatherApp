//
//  ChooseCityViewController.swift
//  WeatherApp
//
//  Created by Reshma Unnikrishnan on 21.08.19.
//  Copyright © 2019 ruvlmoon. All rights reserved.
//

import UIKit

class ChooseCityViewController: UIViewController {

    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var enterCityTextField: UITextField!
    
    var changedCityDelegate : ChangeCityDelegate?

    @IBAction func buttonTouched(_ sender: Any) {
        let userEnteredCity: String = enterCityTextField.text!
        
        if !userEnteredCity.isEmpty {
            changedCityDelegate?.location(city: userEnteredCity)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
