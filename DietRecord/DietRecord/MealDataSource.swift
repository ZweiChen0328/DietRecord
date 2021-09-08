//
//  MealDataSource.swift
//  DietRecord
//
//  Created by 陳奕晴 on 2021/6/7.
//

import Foundation
import UIKit

class MealDataSource{

    private let id: String?
    private let date: String?
    init(id: String,date: String?){
        self.id = id;
        self.date = date;
    }
    var mealist: Array<Meal>{
        get {
            if (id != nil){
                var temp = RpcCall().foodRecordList(id: id!, page: 0)
                print(temp)
                var remove = Array<Meal>()
                if (date != nil){
                    temp?.forEach(){i in
                        var temp2 = (i.time).components(separatedBy: " ")
                        if (temp2[0] == date){
                            remove.append(i)
                        }
                    }
                    return remove
                }
                
                return temp!
            }
            
            return Array<Meal>()
        }
        
    }
}

