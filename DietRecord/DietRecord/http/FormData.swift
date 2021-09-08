//
//  FormData.swift
//  DietRecord
//
//  Created by 陳奕晴 on 2021/5/31.
//

import Foundation
import UIKit

class FormData{
    let name: String
    let filename: String?
    let contentType: String?
    let value: Data

    init(name: String, value: String) {
        self.name = name
        self.filename = nil
        self.contentType = nil
        self.value = value.data(using: .utf8)!
    }
    
    init(name: String, contentType: String, filePath: URL) {
        self.name = name
        //self.filename = ""
        self.filename = filePath.lastPathComponent
        //print(filename!)
        self.contentType = contentType
        print(filePath)
//        self.value = [UInt8](Data(contentsOf: filePath))
        if let data = try? Data(contentsOf: filePath){
            print(data)
            self.value = data
        }else{
            self.value = "".data(using: .utf8)!
        }
       //self.value = filePath
    }
    
    var form:Data{
        get{
            var temp = "Content-Disposition: form-data; name=\"" + name + "\""
            if (filename != nil) {
                temp += "; filename=\"" + filename! + "\""
            }
            var array = temp.data(using: .utf8)
            array!.append(Data("\r\n".utf8))
            
            if (contentType != nil) {
                temp = "Content-Type: " + contentType!
                array!.append(Data(temp.utf8))
                array!.append(Data("\r\n".utf8))
            }
            array!.append(Data("\r\n".utf8))
            array!.append(self.value)

            return array!
        }
    }
}
