//
//  HealthyPlate.swift
//  DietRecord
//
//  Created by 陳奕晴 on 2021/5/19.
//

import UIKit

class HealthyPlate: UIViewController {

    @IBAction func menuClick(_ sender: Any) {
        navigationController?.view.menu()
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
