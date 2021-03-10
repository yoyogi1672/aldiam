//
//  editorViewController.swift
//  aldiam
//
//  Created by Owner on 2021/02/03.
//

import UIKit
import FSCalendar
import RealmSwift

class editorViewController: UIViewController, FSCalendarDelegate, UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var memoTextView: UITextView!
    
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            // デフォルトの画像を表示する
            imageView.image = UIImage(named: "noImage.png")
        }
    }
    @IBOutlet weak var rateLabel: UILabel!
    
    @IBOutlet weak var ratePicker: UIPickerView!
    
    
    var dateLabel: String!
    var imageData: UIImage!
    var imageURL: String!
    var imageName:String!
    var rate: Int!
    var pushedDate: String!
    
    var rateArray:[Int] = ([Int])(1...100)
    
    
    
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
        
        ratePicker.delegate = self
        ratePicker.dataSource = self
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func save(_ sender: Any) {
        do {
            let realm = try Realm()
            let diary = diaryModel()
            let diaries = realm.objects(diaryModel.self)
            
            for diary1 in diaries {
               if diary1.date == pushedDate{
                    try! realm.write {
                        realm.delete(diary1)
                      }
                    return
                }
            }
            
            //let highScore1:Int = ranking.rankig.

            
            saveImageInDocumentDirectory(image: imageData,fileName: pushedDate)
            
            
            diary.title = titleTextField.text ?? ""
            diary.memo = memoTextView.text
            diary.date = pushedDate
            diary.dateString = dateLabel
            diary.iamgeData = imageURL
            diary.rate = rate
            
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
       
        
        for diary in diaries {
            if diary.date == pushedDate{
                titleTextField.text = diary.title
                memoTextView.text = diary.memo
                imageView.image = loadImageFromDocumentDirectory(fileName: diary.iamgeData)
                rateLabel.text = String(diary.rate)
                imageData = loadImageFromDocumentDirectory(fileName: diary.iamgeData)
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
    
    // UIPickerViewの列の数
    func numberOfComponents(in ratePicker: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rateArray.count
    }
    
    // UIPickerViewの行数、リストの数
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> String {
        return String(rateArray.count)
    }
    
    // UIPickerViewの最初の表示
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        rateLabel.text = "1"
        rate = 1
        return String(rateArray[row])
    }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        rate = rateArray[row]
        rateLabel.text = String(rateArray[row])
        
    }
    
    func saveImageInDocumentDirectory(image: UIImage, fileName: String)  {
        
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        imageURL = fileName
        if let imageData = image.pngData() {
            try? imageData.write(to: fileURL, options: .atomic)
        }
    }
    
    func loadImageFromDocumentDirectory(fileName: String) -> UIImage? {
        
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {}
        return nil
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
