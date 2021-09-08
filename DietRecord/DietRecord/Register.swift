//
//  Register.swift
//  DietRecord
//
//  Created by 陳奕晴 on 2021/5/19.
//

import UIKit

class Register: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    var whichBtn: Int?
    let userDefault = UserDefaults()
    
    @IBOutlet weak var Palm: UIButton!
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userID: UITextField!
    
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var weight: UITextField!
    var activityValue:Int?
    var palmImg:UIImage?
    var palmImgurl:URL?
    var fistImg:UIImage?
    var fistImgurl:URL?
    
    var palmUInt8Arr:[UInt8]?
    var fistUInt8Arr:[UInt8]?
    @IBAction func userDataEnter(_ sender: Any) {
        let userEnter = UIAlertController(title: "活動量標準", message: "輕度工作：家務，上班族，售貨員等\n中度工作：保母，護士，服務生等\n重度工作：運動員，搬家工人等", preferredStyle: .alert)
        let enterBtn = UIAlertAction(title: "我知道了", style: .default){_ in
            let actiityEnter = UIAlertController(title: "請選擇", message: "", preferredStyle: .actionSheet)
            let choices = ["輕度", "中度", "重度"]
            for choice in choices{
                let action = UIAlertAction(title: choice, style: .default) { [self] (action) in
                    switch choice{
                    case "輕度":
                        self.activityValue = 1
                    case "中度":
                        self.activityValue = 2
                    case "重度":
                        self.activityValue = 3
                    default:
                        self.activityValue = 0
                    }
                    
                    self.userDefault.setValue(String(self.userID.text!), forKey: "id")
                    self.userDefault.setValue(String(self.userName.text!), forKey: "name")
                    self.userDefault.setValue(self.gender.selectedSegmentIndex, forKey: "gender")
                    self.userDefault.setValue(String(self.weight.text!), forKey: "height")
                    self.userDefault.setValue(String(self.height.text!), forKey: "weight")
                    self.userDefault.setValue(choice, forKey: "activity")
                    //print(self.fistImg!)
                    //print(self.palmImg!)
                    
                    var filename:URL?
                    let palmFilePath = NSTemporaryDirectory() + "palm.jpg"
                    let imagePalm = UIImage(contentsOfFile: palmFilePath)
                    print(imagePalm?.size)
                    if let data = imagePalm?.jpegData(compressionQuality: 1){
                        filename = self.getDocumentsDirectory().appendingPathComponent("palm.jpg")
                        try?data.write(to: filename!)
                    }
                    
                    
                    var filename2:URL?
                    let fistFilePath = NSTemporaryDirectory() + "fist.jpg"
                    let imageFist = UIImage(contentsOfFile: fistFilePath)
                    print(imageFist?.size)
                    if let data2 = imageFist?.jpegData(compressionQuality: 1){
                        filename2 = self.getDocumentsDirectory().appendingPathComponent("fist.jpg")
                        try?data2.write(to: filename2!)
                    }
                    
                    
                    let test = RpcCall()
                    test.updateUserInfo(id: String(self.userID.text!), name: String(self.userName.text!), gender: self.gender.selectedSegmentIndex, height: Float(String(self.weight.text!))!, weight: Float(String(self.weight.text!))!, activity: self.activityValue!, palm: filename!, fist:filename2!)
                    performSegue(withIdentifier: "toDietList", sender: nil)
                }
                actiityEnter.addAction(action)
            }
            
            let cancelAction = UIAlertAction(title: "取消", style: .default, handler: nil)
            actiityEnter.addAction(cancelAction)
            self.present(actiityEnter, animated: true, completion: nil)
        }
        
        userEnter.addAction(enterBtn)
        
        present(userEnter, animated: true, completion: nil)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @IBAction func PalmPhoto(_ sender: Any) {
        print("test.....palm")
        whichBtn = 0
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        //palmImg = imagePicker
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var Fist: UIButton!
    @IBAction func FistPhoto(_ sender: Any) {
        print("test....fist")
        whichBtn = 1
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            switch whichBtn {
            case 0:
                Palm.setImage(image, for: .normal)
                palmImg = image
                if let dataToSave = image.jpegData(compressionQuality: 1){
                    // 產生路徑
                  let filePath = NSTemporaryDirectory() + "palm.jpg"
                  let fileURL = URL(fileURLWithPath: filePath)
                    
                  // 寫入
                  do{
                      try dataToSave.write(to: fileURL)
                  }catch{
                      print("Can not save Image")
                  }
                    if let data = try? Data(contentsOf: fileURL){
                        self.palmUInt8Arr = Array(data)
                        print(self.palmUInt8Arr?.count)
                        //print(self.palmUInt8Arr!)
                    }
                }
            case 1:
                Fist.setImage(image, for: .normal)
                fistImg = image
                if let dataToSave = image.jpegData(compressionQuality: 1){
                    // 產生路徑
                  let filePath = NSTemporaryDirectory() + "fist.jpg"
                  let fileURL = URL(fileURLWithPath: filePath)
                    
                  // 寫入
                  do{
                      try dataToSave.write(to: fileURL)
                  }catch{
                      print("Can not save Image")
                  }
                    if let data = try? Data(contentsOf: fileURL){
                        //print([UInt8](data))
                        self.fistUInt8Arr = Array(data)
                    }
                }
                
            default: break
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func menuClick(_ sender: Any) {
        navigationController?.view.menu()
    }
    
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let idInDB = UserDefaults.standard.string(forKey: "id")
        let nameInDB = UserDefaults.standard.string(forKey: "name")
        let genderInDB = UserDefaults.standard.string(forKey: "gender")
        let heightInDB = UserDefaults.standard.string(forKey: "height")
        let weightInDB = UserDefaults.standard.string(forKey: "weight")
        let activityInDB = UserDefaults.standard.string(forKey: "activity")
        
        if(idInDB == nil || nameInDB == nil || genderInDB == nil || heightInDB == nil || weightInDB == nil || activityInDB == nil){
            print("尚未註冊")
        }else{
            userName.text = nameInDB!
            userID.text = idInDB!
            gender.selectedSegmentIndex = Int(genderInDB!)!
            height.text = heightInDB!
            weight.text = weightInDB!
            print(activityInDB)
            let palmFilePath = NSTemporaryDirectory() + "palm.jpg"
            let imagePalm = UIImage(contentsOfFile: palmFilePath)
            Palm.setImage(imagePalm, for: .normal)
            let fistFilePath = NSTemporaryDirectory() + "fist.jpg"
            let imageFist = UIImage(contentsOfFile: fistFilePath)
            Fist.setImage(imageFist, for: .normal)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
