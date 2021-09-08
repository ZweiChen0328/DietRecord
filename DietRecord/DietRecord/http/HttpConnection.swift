//
//  HttpConnection.swift
//  DietRecord
//
//  Created by 陳奕晴 on 2021/5/31.
//

import Foundation

class HttpConnection{
    
    
    
    init() {
    }
    
    private static let TAG = "HttpConnection"
    private let CRLF = "\r\n"
    private let DASH_DASH = "--"    //var temp2:String?
    var getData:String?
    var postData:String?
    
    
    func httpGet(host: String, file: String?, parameterList: Array<FormUrlEncoded>?) -> Void{
        let path:String? = file
        var temp:[String] = []
        for item in parameterList!{
            temp.append(item.form)
        }
        let query = temp.joined(separator:"&")
        
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = host
        urlComponent.path = "/" + path!
        urlComponent.query = query
        urlComponent.fragment = nil
        
        let sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest = 10000
            sessionConfig.timeoutIntervalForResource = 10000
        let urlRequest = URLRequest(url: urlComponent.url!)
        //var temp2:String?
        connect(url: urlComponent.url!, sessionConfig: sessionConfig, userCompletionHandler: { data in
            if let data = data {
                //self.temp2 = data
                //print(self.temp2)
            }
        })
        
        //return temp2

        //return connect(urlRequest:urlRequest, sessionConfig:sessionConfig)
    }
    
    
    func httpPost(host: String, file: String?, parameterList: Array<FormData>?) -> Void{
        
        let path:String? = file
        var urlComponent = URLComponents()
            urlComponent.scheme = "https"
            urlComponent.host = host
            urlComponent.path = "/" + path!

        let sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest = 10000
            sessionConfig.timeoutIntervalForResource = 10000
            
        var urlRequest = URLRequest(url: urlComponent.url!)
        urlRequest.httpMethod = "POST"
            
        let boundary = UUID().uuidString
            urlRequest.setValue("multipart/form-data; boundary="+boundary, forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        for item in parameterList!{
            print(item.value)
            body.append(Data(DASH_DASH.utf8))
            body.append(Data(boundary.utf8))
            body.append(Data(CRLF.utf8))
            body.append(item.form)
            body.append(Data(CRLF.utf8))
        }
        
        body.append(Data(DASH_DASH.utf8))
        body.append(Data(boundary.utf8))
        body.append(Data(DASH_DASH.utf8))
        
        urlRequest.httpBody = body

        //var temp2:String?
        connectPost(urlRequest: urlRequest, sessionConfig: sessionConfig, userCompletionHandler: { data in
            if let data = data {
                self.postData = data
                print("-----http data-----")
                print(self.postData!)
                var flag = false
                if data != nil{
                    let result = CsvParse().parse(data: data)
                    print(result)
                    flag = result[0][0] == "0"
                }
                print(flag)
                print("-----http data-----\n")
            }
        })
        
        //return temp2
    }
 

    private func connect(url: URL,sessionConfig:URLSessionConfiguration,userCompletionHandler: @escaping (String?) -> Void) {

        var responseCode:Int = 0
        var httpData:Data?
        do {
            let contents = try String(contentsOf: url, encoding: .ascii)
            //print(contents)
            getData = contents
        } catch {
          // handle error
        }
        /*
        let task = URLSession(configuration: sessionConfig).dataTask(with: urlRequest, completionHandler: { data, response, error in

           if let httpResponse = response as? HTTPURLResponse {
                responseCode = httpResponse.statusCode
                httpData = data
                
           }
            if (responseCode == 200){
                userCompletionHandler(String(decoding: httpData!, as: UTF8.self))
            } else {
                userCompletionHandler(nil)
            }
           })
        task.resume()
 */

        }




    private func connectPost(urlRequest: URLRequest,sessionConfig:URLSessionConfiguration,userCompletionHandler: @escaping (String?) -> Void) {

        var responseCode:Int = 0
        var httpData:Data?
        
        let task = URLSession(configuration: sessionConfig).dataTask(with: urlRequest, completionHandler: { data, response, error in

           if let httpResponse = response as? HTTPURLResponse {
                responseCode = httpResponse.statusCode
                httpData = data
            
           }
            if (responseCode == 200){
                userCompletionHandler(String(decoding: httpData!, as: UTF8.self))
            } else {
                userCompletionHandler(nil)
            }
           })

        task.resume()
        }
}
