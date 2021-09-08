//
//  WeightListViewController.swift
//  DietRecord
//
//  Created by 陳奕晴 on 2021/5/28.
//

import UIKit

class WeightListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var refreshControl:UIRefreshControl!
    var weightArr:[String] = []
    //var weightArr = ["40", "50", "30"]
    
    @IBOutlet weak var weightListTableView: UITableView!
    
    
    @IBAction func menuClick(_ sender: Any) {
        navigationController?.view.menu()
    }
    
    @IBAction func addWeight(_ sender: Any) {
        
        let date: Date = Date()
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "zh_Hant_TW") // 設定地區(台灣)
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei") // 設定時區(台灣)
        let dateFormatString: String = dateFormatter.string(from: date)
        print("dateFormatString: \(dateFormatString)") // 2018/05/0029 14:56:55
        
        
        let weightEnter = UIAlertController(title: "請輸入體重", message: "", preferredStyle: .alert)
        weightEnter.addTextField { (textField) in
            textField.placeholder = "體重"
            textField.keyboardType = UIKeyboardType.numberPad
        }
        
        let enterBtn = UIAlertAction(title: "確定", style: .default){_ in
            let weight = weightEnter.textFields?[0].text
            self.weightArr.append("( " + dateFormatString + " ) " + weight!)
            self.weightListTableView.reloadData()
            print(self.weightArr)
        }
        
        let cancelBtn = UIAlertAction(title: "取消", style: .default, handler: nil)
        
        weightEnter.addAction(cancelBtn)
        weightEnter.addAction(enterBtn)
        
        present(weightEnter, animated: true, completion: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weightArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "weightCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.textLabel?.text = weightArr[indexPath.row]
        
        return cell
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        weightListTableView.dataSource = self
        weightListTableView.delegate = self
        // Do any additional setup after loading the view.
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
