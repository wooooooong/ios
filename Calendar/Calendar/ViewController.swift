//
//  ViewController.swift
//  Calendar
//
//  Created by woowabrothers on 2017. 7. 15..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var now =  Date()
    var gregorian =  Calendar(identifier: .gregorian)

    @IBOutlet weak var today: UILabel!
    @IBOutlet weak var korean: UILabel!
    @IBOutlet weak var firstday: UILabel!
    @IBOutlet weak var dateToChange: UITextField!
    @IBOutlet weak var calendar: UITextView!
    
    @IBAction func changeDate(_ sender: Any) {
        now = stringToDate(string: dateToChange.text!)
        let shownDate = showDate(date: now)
        today.text = shownDate
        showCalendar()
    }
    @IBAction func showKorean(_ sender: Any) {
        var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        let year =  String(describing: components.year!)
        let month = String(describing: components.month!)
        let day = String(describing: components.day!)
        
        let shownDate = "\(year)년 \(month)월 \(day)일"
        
        korean.text = shownDate
    }
    @IBAction func showFirstday(_ sender: Any) {
        var components = gregorian.dateComponents([.year, .month, .day], from: now)
        components.day = 1
        let first = gregorian.date(from:components)
        components =  gregorian.dateComponents([.weekday], from: first!)
        let day = components.weekday
        if day == 1{
            firstday.text = "일요일"
        }
        else if day == 2{
            firstday.text = "월요일"
        }
        else if day == 3{
            firstday.text = "화요일"
        }
        else if day == 4{
            firstday.text = "수요일"
        }
        else if day == 5{
            firstday.text = "목요일"
        }
        else if day == 6{
            firstday.text = "금요일"
        }
        else{
            firstday.text = "토요일"
        }
    }
    
    func showDate (date: Date) -> String{
        var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        let year =  String(describing: components.year!)
        let month = String(describing: components.month!)
        let day = String(describing: components.day!)
        let hour = String(describing: components.hour!)
        let minute = String(describing: components.minute!)
        let second = String(describing: components.second!)
        
        let shownDate = "\(year)/\(month)/\(day) \(hour):\(minute):\(second)"
        
        return shownDate
    }
    
    func stringToDate(string: String) -> Date{
        let formatter =  DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        if let date = formatter.date(from: string){
            return date
        }
        else{
            return now
        }
    }
    func showCalendar(){
        var components = gregorian.dateComponents([.year, .month, .day], from: now)
        components.day = 1
        var first = gregorian.date(from:components)
        components =  gregorian.dateComponents([.year, .month, .day, .weekday], from: first!)
        
        var weekday = components.weekday
        
        components.month! += 1
        components.day! -= 1
        
        first = gregorian.date(from:components)
        components = gregorian.dateComponents([.day], from: first!)
        
        let finalday = components.day
        var monthArray = ""
        
        for day in 1...finalday!{
            if weekday! < 7{
                monthArray += String(day)
                monthArray += " "
                weekday! += 1
            }
            else{
                monthArray += String(day)
                monthArray += "\n"
                weekday = 1
            }
        }
        calendar.text = monthArray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let firstDate = showDate(date: now)
        today.text = firstDate
        showCalendar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

