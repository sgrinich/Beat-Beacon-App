//
//  SelectDurationView.swift
//  BeatsByKen
//
/*Copyright (c) 2015 Aidan Carroll, Alex Calamaro, Max Willard, Liz Shank

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
// Modified from original at:
// http://makeapppie.com/2014/09/18/swift-swift-implementing-picker-views/

import Foundation
import UIKit
import CoreData

protocol SelectDurationVCDelegate
{
    func saveText(var trialType: String, var trialDuration: String, var trialIndex: Int)
}
class SelectDurationView: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var delegate : SelectDurationVCDelegate?
    var newTrialDuration : String!
    var selectedTrialType : String!
    var selectedTrialDuration : String!
    var selectedTrialIndex : Int!
    
    @IBOutlet weak var durationPicker: UIPickerView!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var pickerData = [
        ["0","1","2","3","4","5","6","7","8","9"],
        ["0","1","2","3","4","5","6","7","8","9"]
    ]
    enum PickerComponent:Int{
        case tens = 0
        case ones = 1
    }

    //MARK -Instance Methods
    func updateLabel(){
        var tensComponent = PickerComponent.tens.rawValue
        let onesComponent = PickerComponent.ones.rawValue
        let tens = pickerData[tensComponent][durationPicker.selectedRowInComponent(tensComponent)]
        let ones = pickerData[onesComponent][durationPicker.selectedRowInComponent(onesComponent)]
        durationLabel.text = selectedTrialType + " Duration: " + tens + ones
        newTrialDuration = tens + ones
        println(newTrialDuration)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        saveButton.layer.cornerRadius = 15;
        cancelButton.layer.cornerRadius = 15; 
        
        durationPicker.dataSource = self
        durationPicker.delegate = self
        durationPicker.selectRow(2, inComponent: PickerComponent.tens.rawValue, animated: false)
        updateLabel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK -Delgates and DataSource
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateLabel()
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[component][row]
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 30.0
    }

    @IBAction func onSave(sender: AnyObject) {
        if((self.delegate) != nil)
        {
            delegate?.saveText(selectedTrialType, trialDuration: newTrialDuration, trialIndex: selectedTrialIndex);
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    @IBAction func onCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}