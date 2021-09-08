//
//  DailyViewController.swift
//  DietRecord
//
//  Created by 陳奕晴 on 2021/6/4.
//

import UIKit

class DailyViewController: UIViewController {

    @IBOutlet weak var calendar: UIDatePicker!
    var dateStr:String?
    
    
    @IBAction func menuClick(_ sender: Any) {
        navigationController?.view.menu()
    }
    
    @IBAction func selectDate(_ sender: Any) {
        
        let date: Date = calendar.date
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "zh_Hant_TW") // 設定地區(台灣)
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei") // 設定時區(台灣)
        let dateFormatString: String = dateFormatter.string(from: date)
        dateStr = dateFormatString
        print(dateFormatString)
        performSegue(withIdentifier: "ToDailyList", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? DailyListViewController
        controller?.text = dateStr
        //controller?.dailyDate.text = dateStr
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
