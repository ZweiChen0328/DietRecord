//
//  DailyListViewController.swift
//  DietRecord
//
//  Created by 陳奕晴 on 2021/6/4.
//

import UIKit

class DailyListViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    var mealDailyArr:[String] = []
    var img:UIImage?
    var imgData:[UInt8]?
    var imgArr:[UIImage] = []
    var dishListArr:[[Meal.Dish]] = []
    var index:Int?
    let userDefault = UserDefaults()
    var uploadImg:UIImage?
    var mealtime_num:Int?
    var text:String?

    @IBOutlet weak var DailyMealListView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealDailyArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "dailyMealCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = self.mealDailyArr[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "toEnterRecord", sender: nil)
    }
    
    @IBAction func addDailyDiet(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{

            uploadImg = image
            if let dataToSave = image.jpegData(compressionQuality: 1){
                // 產生路徑
              let filePath = NSTemporaryDirectory() + "food_img.jpg"
              let fileURL = URL(fileURLWithPath: filePath)

              // 寫入
              do{
                  try dataToSave.write(to: fileURL)
              }catch{
                  print("Can not save Image")
              }
            }

        }

        dismiss(animated: true, completion: nil)

        let date: Date = Date()
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.locale = Locale(identifier: "zh_Hant_TW") // 設定地區(台灣)
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei") // 設定時區(台灣)
        let dateFormatString: String = dateFormatter.string(from: date)

        let mealtimeEnter = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        let choices = ["早餐", "午餐", "晚餐","點心" ,"下午茶", "宵夜"]

        for choice in choices{
            let action = UIAlertAction(title: choice, style: .default) { (action) in
                switch choice{
                case "早餐":
                    self.mealtime_num = 0
                case "午餐":
                    self.mealtime_num = 1
                case "晚餐":
                    self.mealtime_num = 2
                case "點心":
                    self.mealtime_num = 3
                case "下午茶":
                    self.mealtime_num = 4
                case "宵夜":
                    self.mealtime_num = 5
                default:
                    self.mealtime_num = -1
                }

                self.mealDailyArr.append(dateFormatString + " " + choice)
                self.imgArr.append(self.uploadImg!)
                self.DailyMealListView.reloadData()

                var filename:URL?
                let foodFilePath = NSTemporaryDirectory() + "food_img.jpg"
                let foodimg = UIImage(contentsOfFile: foodFilePath)
                print(self.uploadImg?.size)
                if let data = foodimg?.jpegData(compressionQuality: 1){
                    filename = self.getDocumentsDirectory().appendingPathComponent("food_img.jpg")
                    try?data.write(to: filename!)
                }

                let test = RpcCall()
                test.uploadFood(id: "A131452473", filePath: filename!, type: self.mealtime_num!, date: self.text!)
            }
            mealtimeEnter.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .default, handler: nil)
        mealtimeEnter.addAction(cancelAction)
        present(mealtimeEnter, animated: true, completion: nil)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @IBOutlet weak var dailyDate: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DailyMealListView.dataSource = self
        DailyMealListView.delegate = self
        dailyDate.text = text
        print(text)
        
        let idInDB = UserDefaults.standard.string(forKey: "id")
        if(idInDB != nil){
            let meals = MealDataSource(id: idInDB!, date: text).mealist
            
            for meal in meals{
                var originList = meal.time + " " + meal.mealtimeString
                let imageData = NSData(contentsOf: meal.url)
                let image = UIImage(data: imageData! as Data)
                imgArr.append(image!)
                mealDailyArr.append(originList)
                dishListArr.append(meal.dishList!)
            }
        }
        
        //self.DailyMealListView.reloadData()
        print(mealDailyArr)
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? EnterRecord
        controller?.downloadImg = imgArr
        controller?.dishList = dishListArr
        controller?.index = index
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
