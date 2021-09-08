//
//  EnterRecord.swift
//  DietRecord
//
//  Created by 陳奕晴 on 2021/5/19.
//

import UIKit
import Speech

class EnterRecord: UIViewController, SFSpeechRecognizerDelegate, UITableViewDataSource, UITableViewDelegate{
    
    let Eng = ["Dried tofu","White radish","Broccoli", "spiced corned egg","Plain rice","Scallion Eggs","Sweet potato","Radish scrambled eggs","Qingjiang cuisine","pork","Tonkatsu","Pickled radish","Marinated tofu","Shrimp","Pickled white radish","Red Robb Scrambled Eggs","Scrambled Eggs with Carrots","green pepper","Braised Cabbage","Stewed beef","Shredded Pork with Vegetables","noodles","Water spinach","Braised pork","Fans","Braised pork on rice","sandwich","Stir-fried vegetables","fried tofu","Fried cabbage","Sweet potato rice","Fried corn","Rice blood cake","Mustard","Grilled sausage","Pickled cabbage","Egg Fried Rice","Half a marinated egg","Fried fish steak","cauliflower","Dried small fish","Cucumber soup","White tofu","Fried rice noodles","Quiche","Sushi","Bitter Gourd Soup","Tofu skin","pizza","Fried chicken nuggets","tomato","Red Robes","palm","Brine Chicken","Hard boiled egg","Toast","Bean sprouts","Fried String Beans","pumpkin","milk","Egg bag","Soy milk","bread","Bailuobu","Yan Dumplings","Half a guava","Fried rice with shredded pork","Fried spring rolls","Marinated Chicken Drumsticks","Marinated peanuts","Pork shreds","Marinated Chicken Wings","Fried Noodles with Shredded Pork","Fried egg","Braised Pork Belly","Scrambled Eggs with Shrimp","Minced meat","Brown rice","Boiled egg","Green beans","fried chicken","Braised tofu","Fried shiitake mushrooms","Lubailuobu","Noodle soup","Mapo Tofu","tofu","Stir-fried water spinach","Fried salmon steak","chicken","Enoki mushroom","Stir-fried cabbage","Stir-fried asparagus","Steamed egg","Mashed potatoes","fist","Edamame","eggplant","corn","lettuce","Black beans","Braised Pork Chop","Okra","Tea egg","banana","Yakitori","kelp","Marinated Chicken Wings","Fish meat","Shiitake","Marinated chicken","Half an orange","Fried Rice with Shrimp and Egg","hot dog","Fried dumplings","meatball","Gluten","Bean curd","Carrot shreds","Marinated white radish"]
    
    let Chi = ["豆干","白蘿蔔","青花菜","滷蛋","白飯","蔥蛋","地瓜","蘿蔔炒蛋","青江菜","豬肉","炸豬排","醃製蘿蔔","滷豆腐","蝦仁","醃白蘿蔔","紅羅蔔炒蛋","紅蘿蔔炒蛋","青椒","滷白菜","燉牛肉","青菜肉絲","麵條","空心菜","滷豬肉","粉絲","滷肉飯","三明治","炒青菜","炸豆腐","炒白菜","地瓜飯","炒玉米","米血糕","榨菜","烤香腸","醃高麗菜","蛋炒飯","半顆滷蛋","炸魚排","花椰菜","小魚干","黃瓜湯","白豆腐","炒米粉","蛋餅","壽司","苦瓜湯","豆腐皮","比薩","炸雞塊","蕃茄","紅羅蔔絲","手掌","鹽水雞","白煮蛋","土司","豆芽菜","炒四季豆","南瓜","牛奶","蛋包","豆漿","麵包","白羅蔔","燕餃","半顆芭樂","肉絲炒飯","炸春捲","滷雞腿","滷花生","豬肉絲","滷雞翅膀","肉絲炒麵","煎蛋","滷豬肚","蝦仁炒蛋","肉燥","糙米飯","水煮蛋","四季豆","炸雞","紅燒豆腐","炒香菇","滷白羅蔔","湯麵","麻婆豆腐","豆腐","炒空心菜","煎鮭魚排","雞肉","金針菇","炒高麗菜","炒龍鬚菜","蒸蛋","馬鈴薯泥","拳頭","毛豆","茄子","玉米","生菜","黑豆","滷豬排","秋葵","茶葉蛋","香蕉","烤雞肉串","海帶","滷雞翅","魚肉","香菇","滷雞肉","半顆橘子","蝦仁蛋炒飯","熱狗","煎餃","肉丸","麵筋","豆皮","紅蘿蔔絲","滷白蘿蔔"]
    
    
    var foodNameArr:[String] = []
    var mealArr:[[Meal.Dish]] = []
    var foodRatioArr:[Int] = []
    var dishList:[[Meal.Dish]] = []
    var index:Int?
    var downloadImg:[UIImage] = []
    
    @IBOutlet weak var foodImg: UIImageView!
    
    @IBOutlet weak var enterRecordTableView: UITableView!
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "zh-TW"))  //1
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    
    
    @IBOutlet weak var speechBtn: UIButton!
    @IBOutlet weak var speechResult: UITextField!
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodNameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "dietCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EnterRecordTableViewCell else{
            return UITableViewCell()
        }
        
        cell.foodName.text = foodNameArr[indexPath.row]
        cell.foodRatio.text = String(foodRatioArr[indexPath.row]) +  " / 10"
        cell.ratioSlider.value = Float(foodRatioArr[indexPath.row])
        return cell
    }
 
    
    @IBAction func speech(_ sender: Any) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            speechBtn.isEnabled = false
            //speechBtn.setTitle("Start Recording", for: .normal)
        } else {
            startRecording()
            //speechBtn.setTitle("Stop Recording", for: .normal)
        }
    }
    
    @IBAction func speechEnter(_ sender: Any) {
        let result = speechResult.text
        
        let resultSplit = result!.components(separatedBy: "吃")
        let foodNameStr = resultSplit[0]
        
        let ratio = resultSplit[1]
        if(ratio != "全部"){
            let num = ratio.components(separatedBy: "分之")
            var intNum:Int?
            switch (num[1]){
            case "一":
                intNum = 1
            case "二":
                intNum = 2
            case "三":
                intNum = 3
            case "四":
                intNum = 4
            case "五":
                intNum = 5
            case "六":
                intNum = 6
            case "七":
                intNum = 7
            case "八":
                intNum = 8
            case "九":
                intNum = 9
            default:
                intNum = 0
            }
            print(Int(num[0]))
            print(intNum!)
            print(10 * intNum! / Int(num[0])!)
            var speechRatio = 10 * intNum! / Int(num[0])!
            foodRatioArr.append(speechRatio)
        }else{
            foodRatioArr.append(10)
        }
        foodNameArr.append(foodNameStr)
        self.enterRecordTableView.reloadData()
        print(foodNameStr)
        //print(testRatio)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodImg.image = downloadImg[index!]
        
        for i in dishList{
            mealArr.append(i)
        }
        
        for i in mealArr[index!]{
            var chiFoodName:String = ""
            var indexEng = 0
            for j in Eng{
                if(i.name == j){
                    chiFoodName = Chi[indexEng]
                    break
                }
                indexEng += 1
            }
            foodNameArr.append(chiFoodName)
            foodRatioArr.append(i.eat)
        }
                
        
        speechBtn.isEnabled = false  //2
            
        speechRecognizer!.delegate = self  //3
            
            SFSpeechRecognizer.requestAuthorization { (authStatus) in  //4
                
                var isButtonEnabled = false
                
                switch authStatus {  //5
                case .authorized:
                    isButtonEnabled = true
                    
                case .denied:
                    isButtonEnabled = false
                    print("User denied access to speech recognition")
                    
                case .restricted:
                    isButtonEnabled = false
                    print("Speech recognition restricted on this device")
                    
                case .notDetermined:
                    isButtonEnabled = false
                    print("Speech recognition not yet authorized")
                }
                
                OperationQueue.main.addOperation() {
                    self.speechBtn.isEnabled = isButtonEnabled
                }
            }
        // Do any additional setup after loading the view.
    }
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
     
        /*
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
 */
        
        
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer!.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.speechResult.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                self.audioEngine.inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.speechBtn.isEnabled = true
            }
        })
        
        let recordingFormat = self.audioEngine.inputNode.outputFormat(forBus: 0)
        self.audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        //speechResult.text = "Say something, I'm listening!"
        
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            speechBtn.isEnabled = true
        } else {
            speechBtn.isEnabled = false
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
