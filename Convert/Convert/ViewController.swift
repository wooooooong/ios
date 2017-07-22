//
//  ViewController.swift
//  Convert
//
//  Created by woowabrothers on 2017. 7. 15..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var meterPerSecond: UITextField!
    @IBOutlet weak var meter: UITextField!
    @IBOutlet weak var celcius: UITextField!
    @IBOutlet weak var kmPerHour: UILabel!
    @IBOutlet weak var mile: UILabel!
    @IBOutlet weak var fahrenheit: UILabel!
    
    @IBAction func convertSpeed(_ sender: Any) {
        let str = meterPerSecond.text
        if let dou = Double(str!){
            var speed = Measurement(value: dou, unit: UnitSpeed.metersPerSecond)
            speed.convert(to: UnitSpeed.kilometersPerHour)
            kmPerHour.text = String(describing: speed)
        }
        else{
            kmPerHour.text = "숫자값이 아닙니다."
        }
    }
    
    @IBAction func convertLength(_ sender: Any) {
        let str = meter.text
        if let dou = Double(str!){
            var length = Measurement(value: dou, unit: UnitLength.meters)
            length.convert(to: UnitLength.miles)
            mile.text = String(describing: length)
        }
        else{
            mile.text = "숫자값이 아닙니다."
        }
    }
    
    @IBAction func convertTem(_ sender: Any) {
        let str = celcius.text
        if let dou = Double(str!){
            var temp = Measurement(value: dou, unit: UnitTemperature.celsius)
            temp.convert(to: UnitTemperature.fahrenheit)
            fahrenheit.text = String(describing: temp)
        }
        else{
            fahrenheit.text = "숫자값이 아닙니다."
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

