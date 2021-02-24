//
//  ViewController.swift
//  aldiam
//
//  Created by Owner on 2020/12/27.
//

import UIKit
import FSCalendar
import RealmSwift

class ViewController: UIViewController, FSCalendarDelegate, UITextFieldDelegate {

    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    var textDate:String!
    
    var selectedDate: Date = Date()
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calendar.delegate = self
        
        self.calendar.calendarWeekdayView.weekdayLabels[0].text = "日"
        self.calendar.calendarWeekdayView.weekdayLabels[1].text = "月"
        self.calendar.calendarWeekdayView.weekdayLabels[2].text = "火"
        self.calendar.calendarWeekdayView.weekdayLabels[3].text = "水"
        self.calendar.calendarWeekdayView.weekdayLabels[4].text = "木"
        self.calendar.calendarWeekdayView.weekdayLabels[5].text = "金"
        self.calendar.calendarWeekdayView.weekdayLabels[6].text = "土"
        
        
        let dt = Date()
        let dateFormatter = DateFormatter()
         
        // DateFormatter を使用して書式とロケールを指定する
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "M/dd", options: 0, locale: Locale(identifier: "ja_JP"))
        
        textDate = dateFormatter.string(from: dt)
        dateLabel.text = textDate

        
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        let tmpDate = Calendar(identifier: .gregorian)
        let month = tmpDate.component(.month, from: date)
        let day = tmpDate.component(.day, from: date)
        dateLabel.text = "\(month)/\(day)"
        textDate = "\(month)/\(day)"

        
        displayDiary()
    }
    
    
    
    
    
    func displayDiary(){
        let realm = try! Realm()
        let diaries = realm.objects(diaryModel.self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"


        let dateString = dateFormatter.string(from: selectedDate)
        for diary in diaries {
            if diary.date == dateString{
                titleLabel.text = diary.title
                memoLabel.text = diary.memo
                return
            }
        }
        titleLabel.text = ""
        memoLabel.text = ""

    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
        
    @objc func commitButtonTapped() {
        self.view.endEditing(true)
    }
    
    @IBAction func button(_ sender: Any) {
          let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "next") as! editorViewController
          nextVC.dateLabel = textDate
          nextVC.selectedDate = selectedDate
          self.navigationController?.pushViewController(nextVC, animated: true)
    }
}




