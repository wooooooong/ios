//
//  ViewController.swift
//  Baemin
//
//  Created by woowabrothers on 2017. 7. 18..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit
import AlamofireImage

class ViewController: UIViewController {
    let mainDataProcess = MainDataProcess()
    var jsonArray: Array<Array<Dictionary<String,Any>>> = []
    private func readJson(fileName: String) {
        do {
            if let file = Bundle.main.url(forResource: fileName, withExtension: "json") {
                let data = try Data(contentsOf: file)
                let array = try JSONSerialization.jsonObject(with: data)
                if let object = array as? Array<Dictionary<String,Any>> {
                    jsonArray.append(object)
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        readJson(fileName: "main")
        readJson(fileName: "side")
        readJson(fileName: "soup")
        readJson(fileName: "course")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        let connection = mainDataProcess.isInternetAvailable()
        if connection == true {
            view.layer.borderColor = UIColor.green.cgColor
            view.layer.borderWidth = 1
        } else{
            view.layer.borderColor = UIColor.red.cgColor
            view.layer.borderWidth = 1
        }
        mainDataProcess.loadImage(jsonArray: jsonArray)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return jsonArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonArray[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        let path = jsonArray[indexPath.section][indexPath.row]["detail_hash"] as! String
        
        //cache에서 image 받아오기
        let imageCache = mainDataProcess.getImageCache()
        let image = imageCache.image(withIdentifier: path)
        cell.foodImage.image = image
        
        //image cache에 없으면 url로 받아오기
        if image == nil{
            let url = URL(string: self.jsonArray[indexPath.section][indexPath.row]["image"]! as! String)!
            cell.foodImage.af_setImage(withURL: url)
        }
        
        cell.foodImage.layer.cornerRadius = cell.foodImage.frame.height/2
        cell.foodImage.clipsToBounds = true
        
        cell.title.text = jsonArray[indexPath.section][indexPath.row]["title"] as? String
        cell.detail.text = jsonArray[indexPath.section][indexPath.row]["description"] as? String
        if jsonArray[indexPath.section][indexPath.row]["s_price"] != nil {
            cell.salePrice.text = jsonArray[indexPath.section][indexPath.row]["s_price"] as? String
            if !(cell.salePrice.text?.contains("원"))! {
                cell.salePrice.text? += "원"
            }
        } else {
            cell.salePrice.text = jsonArray[indexPath.section][indexPath.row]["n_price"] as? String
            if !(cell.salePrice.text?.contains("원"))! {
                cell.salePrice.text? += "원"
            }
        }
        if jsonArray[indexPath.section][indexPath.row]["n_price"] != nil {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: (jsonArray[indexPath.section][indexPath.row]["n_price"] as? String)!)
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.price.attributedText = attributeString
            cell.salePrice.center.x = 230
        } else {
            cell.price.text=""
            cell.salePrice.center.x = 190
        }
        let badges = jsonArray[indexPath.section][indexPath.row]["badge"] as? [String]
        if badges != nil {
            if (badges?.contains("론칭특가"))! {
                if (badges?.contains("이벤트특가"))! {
                } else{ //론칭특가만 있는 경우
                    cell.event.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
                    cell.event.text = ""
                }
            } else { //이벤트특가만 있는 경우
                cell.event.center.x = 185
                cell.launching.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
                cell.launching.text = ""
            }
        } else {
            cell.launching.text = ""
            cell.launching.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
            cell.event.text = ""
            cell.event.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerText = UILabel()
        headerText.backgroundColor = UIColor.white
        headerText.textColor = UIColor.darkGray
        headerText.adjustsFontSizeToFitWidth = true
        headerText.textAlignment = .center
        headerText.layer.borderColor = UIColor.lightGray.cgColor
        headerText.layer.borderWidth = 1
        switch section{
        case 0:
            headerText.text = "언제먹어도 든든한 밑반찬"
        case 1:
            headerText.text = "사이드 반찬"
        case 2:
            headerText.text = "김이 모락모락 국, 찌개"
        default:
            headerText.text = "코스 요리"
        }
        
        return headerText
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70.0
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ProductDetailViewController {
            let destination =  segue.destination as? ProductDetailViewController
            let indexSection = tableView.indexPathForSelectedRow?.section
            let indexRow = tableView.indexPathForSelectedRow?.row
            let hashValue = "http://52.78.212.27:8080/woowa/detail/" + (jsonArray[indexSection!][indexRow!]["detail_hash"] as? String)!
            destination?.detailHash = hashValue
            destination?.titleLabel = (jsonArray[indexSection!][indexRow!]["title"] as? String)!
            if (jsonArray[indexSection!][indexRow!]["s_price"] as? String) != nil {
                destination?.price = (jsonArray[indexSection!][indexRow!]["s_price"] as? String)!
                if !(destination?.price.contains("원"))! {
                    destination?.price += "원"
                }
            } else {
                destination?.price = (jsonArray[indexSection!][indexRow!]["n_price"] as? String)!
                if !(destination?.price.contains("원"))! {
                    destination?.price += "원"
                }
            }

        }
    }
}









