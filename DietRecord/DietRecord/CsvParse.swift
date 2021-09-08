//
//  CsvParse.swift
//  DietRecord
//
//  Created by 陳奕晴 on 2021/5/31.
//

import Foundation

struct CsvParse{
    
    func parse(data: String) -> Array<Array<String>> {
        let temp = data.components(separatedBy: "\n")
        
        //print(temp)
        var ar = Array<Array<String>>()
        for item in temp{
            //print(item)
          ar.append(parseLine(data:item))
        }
        //print(ar)
        return ar
    }
    
    private func parseLine(data: String) -> Array<String>{
        var i = 0
        var temp = Array<String>()
        //print(data.count)
        while(i < data.count) {
            var str = ""
            //print(data[data.index(data.startIndex, offsetBy: i)])
            while(i < data.count){
                if(data[data.index(data.startIndex, offsetBy: i)] == " "){
                    str.append(data[data.index(data.startIndex, offsetBy: i)])
                    i+=1
                }else{
                    break
                }
            }
            
            if( (i < data.count) && data[data.index(data.startIndex, offsetBy: i)] == "\""){
                str.append(data[data.index(data.startIndex, offsetBy: i)])
                i+=1
                //print(data.count)
                while(i < data.count){
                    if(data[data.index(data.startIndex, offsetBy: i)] == "\""){
                        str.append(data[data.index(data.startIndex, offsetBy: i)])
                        i+=1
                        break
                    }else if( (data[data.index(data.startIndex, offsetBy: i)] == "\\") && ((i + 1) < data.count)){
                         str.append(data[data.index(data.startIndex, offsetBy: i)])
                         i+=1
                         str.append(data[data.index(data.startIndex, offsetBy: i)])
                         i+=1
                    }else{
                         str.append(data[data.index(data.startIndex, offsetBy: i)])
                         i+=1
                    }
                }
            }
            
            while(i < data.count) {
              if(data[data.index(data.startIndex, offsetBy: i)] == ","){
                  break
              }else{
                str.append(data[data.index(data.startIndex, offsetBy: i)])
                i+=1
              }
            }
            //print(str)
            temp.append(handleEscape(data:str))
            i+=1
        }
        //print(temp)
        return temp
    }
        
    private func handleEscape(data: String) -> String {
    let str = data.trimmingCharacters( in : .whitespaces)
        if((str.count > 1) && str.hasPrefix("\"") && str.hasSuffix("\"")){
            let start = str.index(str.startIndex, offsetBy: 1)
            let end = str.index(str.endIndex, offsetBy: -1)
            let range = start..<end
            var myString = String(str[range])
            myString = myString.replacingOccurrences(of:"\\\\",with : "\\")
            .replacingOccurrences(of:"\\\"",with : "\"")
            .replacingOccurrences(of:"\\\'",with : "\'")
            .replacingOccurrences(of:"\\n'",with : "\n")
            return myString
        }else{
            return str
        }
    }
}


