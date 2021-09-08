//
//  Meal.swift
//  DietRecord
//
//  Created by 陳奕晴 on 2021/5/31.
//

import Foundation
import UIKit

struct Meal {
    let id: String
    let time: String
    let url: URL
    let mealtime: Int
    let dishList: Array<Dish>?
    
    func dishColor(index: Int)-> UIColor {
        switch((index + 1) % 8){
            case 0:
                return UIColor.black
            case 1:
                return UIColor.blue
            case 2:
                return UIColor.green
            case 3:
                return UIColor.red
            case 4:
                return UIColor.cyan
            case 5:
                return UIColor.magenta
            case 6:
                return UIColor.yellow
        default:
            return UIColor.white
        }
    }

    var mealtimeString: String{
        get{
            var temp:String?
            switch mealtime {
            case 0:
                temp = "早餐"
                break
            case 1:
                temp = "午餐"
                break
            case 2:
                temp = "晚餐"
                break
            case 3:
                temp = "點心"
                break
            case 4:
                temp = "下午茶"
                break
            case 5:
                temp = "宵夜"
                break
            default:
                temp = ""
                break
            }
            if (dishList == nil){
                temp = temp! + "(尚未辨識)"
            }else{
                temp = temp! +  ""
            }
            return temp!
        }
    }

    var dishJSON: Array<Data>{
        get{
            var array = [Data]()
            for item in dishList!{
                var temp : [String: Any] = ["name":item.name]
                if (item.rect != nil){
                    temp["left_x"] = item.rect?.minX
                    temp["top_y"] = item.rect?.maxY
                    temp["width"] = item.rect?.width
                    temp["height"] = item.rect?.height
                }
                temp["eat"] = item.eat
                temp["delete"] = item.delete
                do {
                    array.append( try JSONSerialization.data(withJSONObject: temp, options: []) )
                }catch {
                    print(error)
                }
            }
            return array
        }
    }
    class Dish{
        let name: String
        let rect: CGRect?
        let eat: Int
        var delete: Bool
        init(name: String,rect: CGRect?, eat: Int, delete: Bool){
            self.name = name;
            self.rect = rect;
            self.eat = eat;
            self.delete = delete;
        }
    }
}





