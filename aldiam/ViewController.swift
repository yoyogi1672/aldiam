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
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var memoTextView: UITextView!
    
    @IBOutlet weak var button: UIButton!
    
    var selectedDate: Date = Date()
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calendar.delegate = self
        titleTextField.delegate = self
        
        self.calendar.calendarWeekdayView.weekdayLabels[0].text = "日"
        self.calendar.calendarWeekdayView.weekdayLabels[1].text = "月"
        self.calendar.calendarWeekdayView.weekdayLabels[2].text = "火"
        self.calendar.calendarWeekdayView.weekdayLabels[3].text = "水"
        self.calendar.calendarWeekdayView.weekdayLabels[4].text = "木"
        self.calendar.calendarWeekdayView.weekdayLabels[5].text = "金"
        self.calendar.calendarWeekdayView.weekdayLabels[6].text = "土"
        
        let rgba = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.0) // ボタン背景色設定
        button.backgroundColor = rgba                                               // 背景色
        button.layer.borderWidth = 0                                              // 枠線の幅
        button.layer.borderColor = UIColor.black.cgColor                            // 枠線の色
        button.layer.cornerRadius = 3.0                                             // 角丸のサイズ
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        // ツールバー生成 サイズはsizeToFitメソッドで自動で調整される。
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

            //サイズの自動調整。敢えて手動で実装したい場合はCGRectに記述してsizeToFitは呼び出さない。
        toolBar.sizeToFit()

            // 左側のBarButtonItemはflexibleSpace。これがないと右に寄らない。
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
            // Doneボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(commitButtonTapped))

            // BarButtonItemの配置
        toolBar.items = [spacer, commitButton]
            // textViewのキーボードにツールバーを設定
        memoTextView.inputAccessoryView = toolBar
        
        
        
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
            
            // タイトルと本文をここで決めるよ
            let alert: UIAlertController = UIAlertController(title: "完了", message: "保存されました", preferredStyle: .alert)

            // OKボタンを作る
            let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            // OKボタンを初めに作ったアラートに紐づけているよ
            alert.addAction(okAction)

            // 実際にアラートを表示するよ
            self.present(alert, animated: true, completion: nil)
            
        } catch {
            print("create todo error.")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        titleTextField.resignFirstResponder()
        return true
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
        titleTextField.text = ""
        memoTextView.text = ""

    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
        
    @objc func commitButtonTapped() {
        self.view.endEditing(true)
    }
}



