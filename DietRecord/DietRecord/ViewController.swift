//
//  ViewController.swift
//  DietRecord
//
//  Created by 陳奕晴 on 2021/5/19.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet var DietListView: UIView!
    
    @IBOutlet var DailyView: UIView!
    
    @IBOutlet var WeightListView: UIView!
    
    @IBOutlet var HealthyPlateView: UIView!
    
    
    
    @IBOutlet var RegisterView: UIView!
    
    let list = ["首頁", "每日紀錄", "體重紀錄", "查看卡路里", "健康餐盤說明", "設定個人資料"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = list[indexPath.row]
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let cameraAction = UIAlertAction(title: "相機", style: .default){(_) in
            
            switch AVCaptureDevice.authorizationStatus(for: .video){
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { success in
                    guard success == true else { return }
                    //self.presentCamera()
                }
                
            case .denied, .restricted:
                let alertController = UIAlertController (title: "相機啟用失敗", message: "相機服務未啟用", preferredStyle: .alert)
                let settingsAction = UIAlertAction(title: "設定", style: .default) { (_) -> Void in

                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }

                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                }
                alertController.addAction(settingsAction)
                let cancelAction = UIAlertAction(title: "確認", style: .default, handler: nil)
                alertController.addAction(cancelAction)

                self.present(alertController, animated: true, completion: nil)
                return
            case .authorized:
                print("Authorized, proceed")
                //self.presentCamera()
            }
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DietListView.frame = view.frame
        view.addSubview(DietListView)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var tmpView: UIView!
        let workingView = view.subviews.last
        
        if indexPath.row == 0{
            tmpView = DietListView
        } else if indexPath.row == 1{
            tmpView = DailyView
        } else if indexPath.row == 2{
            tmpView = WeightListView
        } else if indexPath.row == 3{
            tmpView = DietListView
        } else if indexPath.row == 4{
            tmpView = HealthyPlateView
        } else if indexPath.row == 5{
            tmpView = RegisterView
        }
        
        if workingView != tmpView {
            tmpView.frame = (workingView?.frame)!
            workingView?.removeFromSuperview()
            view.addSubview(tmpView)
            tmpView.subviews.last?.menu()
        }
        
        
    }

}

