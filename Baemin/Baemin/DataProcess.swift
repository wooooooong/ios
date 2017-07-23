//
//  DataProcess.swift
//  Baemin
//
//  Created by woowabrothers on 2017. 7. 19..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration
import Alamofire
import AlamofireImage

class DataProcess {
    private var jsonArray = [String: Any]()
    private let detailImageCache = AutoPurgingImageCache()
    func getDetailImageCache() -> AutoPurgingImageCache {
        return detailImageCache
    }
    func getJson() -> [String: Any] {
        return jsonArray
    }
    func dataRequest(url: String) {
        Alamofire.request(url)
            .responseJSON { response in
                self.jsonArray = response.result.value as! [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name("dataArray"), object: self)
        }
    }
    func dataPost(text: String) {
        let dict = ["text": text, "username" : "jw", "icon_url" : "http://emojis.slackmojis.com/emojis/images/1490885301/1973/mario_luigi_dance.gif?1490885301"] as [String: Any]
        if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) {
            var request = URLRequest(url: URL(string: "https://hooks.slack.com/services/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")!)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                } else{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "post"), object: self)
                }
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
            }
            task.resume()
        }
    }
    func loadImage(dataArray: [String: Any]){
        let thumbArray = dataArray["thumb_images"] as! [String]
        let detailArray = dataArray["detail_section"] as! [String]
        for i in 0..<thumbArray.count {
            let url = URL(string: thumbArray[i])!
            do{
                let image =  try UIImage.af_threadSafeImage(with: Data(contentsOf: url))
                // Add
                let directory = thumbArray[i].components(separatedBy: "/")
                let path = directory[directory.count-1]
                detailImageCache.add(image!, withIdentifier: path)
            }
            catch {
                print("error")
            }
        }
        for i in 0..<detailArray.count {
            let url = URL(string: detailArray[i])!
            do{
                let image =  try UIImage.af_threadSafeImage(with: Data(contentsOf: url))
                // Add
                let directory = detailArray[i].components(separatedBy: "/")
                let path = directory[directory.count-1]
                detailImageCache.add(image!, withIdentifier: path)
            }
            catch {
                print("error")
            }
        }
    }

    /* downloaTask써서 캐시에 저장
    func load(jsonArray: Dictionary<String,Any>){
        let fileManager = FileManager.default
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let cache = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
        let thumbArray = jsonArray["thumb_images"] as! [String]
        for i in 0..<thumbArray.count {
            var request = URLRequest(url: URL(string: thumbArray[i])!)
            request.httpMethod = "GET"
            session.downloadTask(with: request) { tmp, response, error in
                guard let tmp = tmp, error == nil else {
                    // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    return
                }
                // tmp 파일을 cache 디렉토리에 저장하기
                do {
                    let directory = thumbArray[i].components(separatedBy: "/")
                    let path = directory[directory.count-1]
                    let image = cache?.appendingPathComponent(path)
                    let imagePath = image!.path
                    ////////////
                    print("data")
                    try fileManager.moveItem(atPath: tmp.path, toPath: imagePath)
                }
                catch _ as NSError {
                }
                }.resume()
        }
        let detailArray = jsonArray["detail_section"] as! [String]
        for i in 0..<detailArray.count {
            var request = URLRequest(url: URL(string: detailArray[i])!)
            request.httpMethod = "GET"
            session.downloadTask(with: request) { tmp, response, error in
                guard let tmp = tmp, error == nil else {
                    // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    return
                }
                // tmp 파일을 cache 디렉토리에 저장하기
                do {
                    let directory = detailArray[i].components(separatedBy: "/")
                    let path = directory[directory.count-1]
                    let image = cache?.appendingPathComponent(path)
                    try fileManager.moveItem(at: tmp, to: image!)
                }
                catch _ as NSError {
                }
                }.resume()
        }
 
    }
 */
}
