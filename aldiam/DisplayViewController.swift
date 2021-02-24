//
//  DisplayViewController.swift
//  aldiam
//
//  Created by Owner on 2021/02/10.
//

import UIKit
import RealmSwift

class DisplayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    @IBOutlet var table: UITableView!
    var realm: Realm!
    
    var diaries: Results<diaryModel>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self

        // Realmの初期化
        realm = try! Realm()
        
        diaries = realm.objects(diaryModel.self)
        table.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        diaries = realm.objects(diaryModel.self)
        table.reloadData()
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return diaries.count
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = diaries[indexPath.row].date + " - " +  diaries[indexPath.row].memo
        return cell
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
