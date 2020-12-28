//
//  ViewController.swift
//  aldiam
//
//  Created by Owner on 2020/12/27.
//

import UIKit
import FSCalendar
import RealmSwift

class ViewController: UIViewController, FSCalendarDelegate {

    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var memoTextView: UITextView!
    
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
        
        
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        displayDiary()
    }
    
    @IBAction func save(_ sender: Any) {
        do {
            let realm = try Realm()
            let diary = diaryModel()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd"


            let dateString = dateFormatter.string(from: selectedDate)
            diary.title = titleTextField.text ?? ""
            diary.memo = memoTextView.text
            diary.date = dateString
            
            
            try realm.write {
                realm.add(diary)
            }
        } catch {
            print("create todo error.")
        }
    }
    
    func displayDiary(){
        let realm = try! Realm()
        let diaries = realm.objects(diaryModel.self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"


        let dateString = dateFormatter.string(from: selectedDate)
        for diary in diaries {
            if diary.date == dateString{
                titleTextField.text = diary.title
                memoTextView.text = diary.memo
                return
            }
        }
    }


}

