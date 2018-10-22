//
//  PickerViewController.swift
//  Neighborhood
//
//  Created by Cindy Bishop on 10/17/18.
//  Copyright © 2018 LoopyLoo. All rights reserved.
//

import UIKit

enum IncomeBracket: Int {
    // do we want an 0 for no-selection?
    case low = 1
    case middle = 2
    case high = 3
}
enum RaceIdentity: Int {
    case black = 1
    case brown = 2
    case pink = 3
    case offwhite = 4
    case red = 5
}
enum Choice: Int {
    case food = 1
    case bar = 2
    case people = 3
}
enum ChoiceAmount: Int {
    case poor = 1
    case fair = 2
    case great = 3
}
enum DistanceFromMIT: Int {
    case under10 = 1
    case under20 = 2
    case under30 = 3
    case above30 = 4
}

enum Persona : Int {
    case FACSTAFF = 0
    case STUDENT = 1 // low income,
    case FELLOW = 2
}

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var distancePicker: UIPickerView!
    @IBOutlet weak var incomePicker: UIPickerView!
    @IBOutlet weak var racePicker: UIPickerView!
    
    // @IBOutlet weak var interestsPicker: UIPickerView!
    // @IBOutlet weak var mirrordSlider: UISlider!
    
    // var personaDataSource = [ "Faculty", "Fellow","Staff", "Student","Visitor"]
    var incomeDataSource = [ "under 50k", "50k-75k","80k-100k","above 100k", "above 200k"]
    var raceDataSource = [ "Asian", "Black or African American", "Latino or Hispanic", "Native American (not in census)",  "White alone, not Hispanic/Latino", "Other"]
    var distanceDataSource = [ "5 miles", "10 miles","20 miles", "above 20"]
    var educationDataSource = [ "no college degree or equivalent", "college degree", "advanced degree"]
    var interestsDataSource = [ "safety", "bikeable", "urban"]
    
    private var persona = Persona.STUDENT
    private var income = IncomeBracket.middle
    private var race = RaceIdentity.red
    private var interests = Choice.people
    private var distance = DistanceFromMIT.under10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        distancePicker.dataSource = self
        distancePicker.delegate = self
        incomePicker.dataSource = self
        incomePicker.delegate = self
        racePicker.dataSource = self
        racePicker.delegate = self
        /*interestsPicker.dataSource = self
        interestsPicker.delegate = self*/

    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == distancePicker {
            return distanceDataSource.count;
        } else if pickerView == incomePicker {
            return incomeDataSource.count
        } else if pickerView == racePicker {
            return raceDataSource.count
        } /* else if pickerView == interestsPicker {
            return interestsDataSource.count
        } */
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerView == distancePicker {
            return distanceDataSource[row]
        } else if pickerView == incomePicker {
            return incomeDataSource[row]
        } else if pickerView == racePicker {
            return raceDataSource[row]
        } /*else if pickerView == interestsPicker {
            return interestsDataSource[row]
        }*/
        return "none"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    { //check all of these to map themp properly
        if pickerView == distancePicker {
            if(row == 0){
                distance = DistanceFromMIT.under10;
            }else if(row == 1) {
                distance = DistanceFromMIT.under20;
            }else if(row == 2) {
                distance = DistanceFromMIT.under30;
            } else{
                distance = DistanceFromMIT.above30;
            }
        }  else if pickerView == incomePicker {
            if(row == 0) {
                income = IncomeBracket.low;
            } else if(row == 1 || row == 2) {
                income = IncomeBracket.middle;
            } else if(row == 3 || row == 4){
                income = IncomeBracket.high;
            }
        } else if pickerView == racePicker {
            return race = RaceIdentity.red
        }
    }
    
    func applyProfileInfo() {
        // get settings and set up UI visuals
        //which colors over what tracts
    }

    @IBAction func closePopover(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    @IBAction func doSomething(sender: UIButton) {
        if sender == applyButton {
            applyProfileInfo()
            self.view.removeFromSuperview()
            
        }
    }
}
