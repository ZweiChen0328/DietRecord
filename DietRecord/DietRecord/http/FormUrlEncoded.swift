//
//  FormUrlEncoded.swift
//  DietRecord
//
//  Created by 陳奕晴 on 2021/5/31.
//

import Foundation

struct FormUrlEncoded {

    let name: String
    let value: String
    var form: String{
        get{
            return "" + name + "=" + value
        }
    }
}


