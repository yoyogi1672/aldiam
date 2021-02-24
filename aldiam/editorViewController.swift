//
//  editorViewController.swift
//  aldiam
//
//  Created by Owner on 2021/02/03.
//

import UIKit
import FSCalendar
import RealmSwift

class editorViewController: UIViewController, FSCalendarDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var memoTextView: UITextView!
    
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            // デフォルトの画像を表示する
            imageView.image = UIImage(named: "noImage.png")
        }
    }
    
    
    var selectedDate: Date!
    var dateLabel: String!
    var imageData: UIImage!

      

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //calendar.delegate = self
        titleTextField.delegate = self
        
        
        labelDate.text = dateLabel
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
        displayDiary()
        

        // Do any additional setup after loading the view.
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
            diary.iamgeData = imageData! as NSData
            
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
    
    @IBAction func selectPicture(_ sender: UIButton) {
        // カメラロールが利用可能か？
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            // 写真を選ぶビュー
            let pickerView = UIImagePickerController()
            // 写真の選択元をカメラロールにする
            // 「.camera」にすればカメラを起動できる
            pickerView.sourceType = .photoLibrary
            // デリゲート
            pickerView.delegate = self
            // ビューに表示
            self.present(pickerView, animated: true)
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
                imageView.image = UIImage(data: diary.iamgeData as Data)
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension editorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 写真を選んだ後に呼ばれる処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
        // 選択した写真を取得する
        let image = info[.originalImage] as! UIImage
        
        imageData = image
    
        // ビューに表示する
        imageView.image = image
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
    }
}
