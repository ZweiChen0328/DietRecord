//
//  RpcCall.swift
//  DietRecord
//
//  Created by 陳奕晴 on 2021/5/31.
//

import Foundation
import Dispatch
import UIKit

struct RpcCall {
    private static let TAG = "RpcCall"
    
    func updateUserInfo(
        id: String,
        name: String,
        gender: Int,
        height: Float,
        weight: Float,
        activity: Int,
        palm: URL,
        fist: URL
    ) -> Void {
       let parameterList = [
            FormData(name:"__rpcname",value: "Robot/FoodUserInfoUpdate"),
            FormData(name:"__style",value: "csv"),
            FormData(name:"__ds", value:"site"),
            FormData(name:"__dbid",value: "2"),
            FormData(name:"__ver",value: "2"),
            FormData(name:"charset",value: "utf8"),
            FormData(name:"id",value: id),
            FormData(name:"name",value: name),
            FormData(name:"gender",value: "\(gender)"),
            FormData(name:"height",value: "\(height)"),
            FormData(name:"weight",value: "\(weight)"),
            FormData(name:"activity",value: "\(activity)"),
            FormData(name:"palm_img",contentType: "image/jpeg",filePath: palm),
            FormData(name:"fist_img",contentType: "image/jpeg",filePath: fist)]
        
        DispatchQueue.global(qos: .utility).async {
            let httpConnect = HttpConnection()
            httpConnect.httpPost(host: "robot.cyberhood.net", file: "rpc2.php", parameterList: parameterList)
        }
    }
    
    func uploadFood(id: String, filePath: URL, type: Int, date:String) -> Void{
        let parameterList = [
             FormData(name:"__rpcname",value: "Robot/FoodUpload"),
             FormData(name:"__style",value: "csv"),
             FormData(name:"__ds", value:"site"),
             FormData(name:"__dbid",value: "2"),
             FormData(name:"__ver",value: "2"),
             FormData(name:"id",value: id),
            FormData(name: "food_img", contentType: "image/jpeg", filePath: filePath),
            FormData(name: "type", value: "\(type)"),
            FormData(name: "food_time", value: date)]
        
        DispatchQueue.global(qos: .utility).async {
            let httpConnect = HttpConnection()
            httpConnect.httpPost(host: "robot.cyberhood.net", file: "rpc2.php", parameterList: parameterList)
        }
    }
    
    
    func foodRecordList(id: String, page: Int)-> Array<Meal>? {
        let parameterList = [
            FormUrlEncoded(name:"__rpcname",value: "Robot/FoodRecordList"),
            FormUrlEncoded(name:"__style",value: "csv"),
            FormUrlEncoded(name:"__ds",value: "site"),
            FormUrlEncoded(name:"__dbid",value: "2"),
            FormUrlEncoded(name:"__ver",value: "2"),
            FormUrlEncoded(name:"charset",value: "utf8"),
            FormUrlEncoded(name:"id",value: id),
            FormUrlEncoded(name:"page",value: String(page))]

        var temp:[Meal]? = [Meal]()

        //DispatchQueue.global(qos: .utility).async {
            var httpConnect = HttpConnection()
            httpConnect.httpGet(host: "robot.cyberhood.net", file: "rpc2.php", parameterList: parameterList)
            if let httpResult = httpConnect.getData{
                var result = CsvParse().parse(data:httpResult)
                if(result[0][0] == "0"){
                    result.removeFirst(1)
                    for mealList in result{
                        let mealId = mealList[0]
                        let time = mealList[1]
                        let url = URL(string:mealList[2])
                        let mealtime = Int(mealList[3])
                        var dishList =  Array<Meal.Dish>()
                        //print(mealList[4])
                        if (mealList[4] != "[]"){
                            struct dish: Codable {
                                let name:String
                                let prob:String
                                let left_x:Int?
                                let top_y:Int?
                                let width:Int?
                                let height:Int?
                                //let eat:Int
                                //let delete:Bool
                            }
                            
                            let jsonData = mealList[4].data(using: .utf8)!

                            do {
                                if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options : .allowFragments) as? [Dictionary<String,String>]
                                {
                                    //print(jsonArray)
                                    for dishData in jsonArray{
                                        var name =  dishData["name"]!
                                        var rect = CGRect(x: Int(dishData["left_x"]!)!, y: Int(dishData["top_y"]!)!, width: Int(dishData["width"]!)!, height: Int(dishData["height"]!)!)
                                        dishList.append(Meal.Dish(name: name as! String, rect: rect, eat: 10, delete: false))
                                    }
                                } else {
                                    print("bad json")
                                }
                                //print(dishList)
                                temp?.append(Meal(id: mealId, time: time, url: url!, mealtime: mealtime!, dishList: dishList))
                                
                            }catch let error as NSError {
                                print("error")
                            }
                        }
                    }
                }else{
                    temp = nil
                }
            }else{
                temp = nil
            }
        //}
        return temp
    }
    

    func updateFoodRecord(id: String, meal: Meal)-> Bool {
           let parameterList = [
                FormUrlEncoded(name:"rpcname",value: "Robot/FoodRecordUpdate"),
                FormUrlEncoded(name:"style",value: "csv"),
                FormUrlEncoded(name:"ds",value: "site"),
                FormUrlEncoded(name:"dbid",value: "2"),
                FormUrlEncoded(name:"__ver",value: "2"),
                FormUrlEncoded(name:"charset",value: "utf8"),
                FormUrlEncoded(name:"id",value: id),
                FormUrlEncoded(name:"img_id",value: meal.id),
                FormUrlEncoded(name:"food_json",value: String(meal.dishJSON.description))]
            var flag = false
            //DispatchQueue.global().async {
    //        if let httpResult = HttpConnection().httpGet(host:"robot.cyberhood.net", file:"rpc2.php",parameterList: parameterList){
    //       let result = CsvParse().parse(data:httpResult)
    //        flag = result[0][0] == "0"
    //      }

    //}
            return flag
    }


}
