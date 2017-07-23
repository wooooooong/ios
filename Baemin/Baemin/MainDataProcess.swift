//
//  MainDataProcess.swift
//  Baemin
//
//  Created by woowabrothers on 2017. 7. 19..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration
import AlamofireImage
import Alamofire

class MainDataProcess {
    private let imageCache = AutoPurgingImageCache()
    func getImageCache() -> AutoPurgingImageCache {
        return imageCache
    }
    func loadImage(jsonArray: Array<Array<Dictionary<String,Any>>>){
        for i in 0..<jsonArray.count {
            for j in 0..<jsonArray[i].count {
                let menuArray = jsonArray[i][j]
                let url = URL(string: menuArray["image"] as! String)
                let path = "\(String(describing: menuArray["detail_hash"]!))"
                do{
                    let image = try UIImage.af_threadSafeImage(with: Data(contentsOf: url!))
                    // Add
                    imageCache.add(image!, withIdentifier: path)
                }
                catch{
                    print("error")
                }
            }
        }
    }
    /* downloadTask써서 캐시에 저장
    func mainImageLoad(jsonArray: Array<Dictionary<String,Any>>){
        let fileManager = FileManager.default
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let cache = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
        for i in 0..<jsonArray.count {
            let menuArray = jsonArray[i]
            let url = menuArray["image"] as! String
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = "GET"
            session.downloadTask(with: request) { tmp, response, error in
                guard let tmp = tmp, error == nil else {
                    // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    return
                }
                    // tmp 파일을 cache 디렉토리에 저장하기
                do {
                    let path = "\(String(describing: menuArray["detail_hash"]!)).jpg"
                    let image = cache?.appendingPathComponent(path)
                    try fileManager.moveItem(at: tmp, to: image!)
                }
                catch _ as NSError {
                }
                }.resume()
            }
        }
    */
    func isInternetAvailable() -> Bool
        //최신버전아님
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
}

