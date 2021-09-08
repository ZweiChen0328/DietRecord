//
//  EnterRecordTableViewCell.swift
//  DietRecord
//
//  Created by 陳奕晴 on 2021/6/7.
//

import UIKit

class EnterRecordTableViewCell: UITableViewCell {

    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var ratioSlider: UISlider!
    @IBOutlet weak var foodRatio: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBAction func changeRatio(_ sender: UISlider) {
        foodRatio.text = String(Int(self.ratioSlider.value)) + " / 10"
    }
    
    
    
    var temp = 1
    @IBAction func cancel(_ sender: Any) {
        if(temp == 1){
            
            temp = 0
        }else{
            temp = 1
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
