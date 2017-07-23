//
//  ProductDetailViewController.swift
//  Baemin
//
//  Created by woowabrothers on 2017. 7. 19..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit
import AlamofireImage

class ProductDetailViewController: UIViewController {
    @IBOutlet weak var topImage: UIScrollView!
    @IBOutlet weak var detailImage: UIScrollView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productDetail: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var point: UILabel!
    @IBOutlet weak var deliveryInfo: UILabel!
    @IBOutlet weak var deliveryFee: UILabel!
    @IBOutlet weak var deliveryPossibility: UILabel!
    @IBAction func order(_ sender: Any) {
        let productTitleText = productTitle.text!
        let orderText = "\(String(describing: productTitleText))를 주문하였습니다."
        dataProcess.dataPost(text: orderText)
    }
    var detailHash: String = ""
    var titleLabel: String = ""
    var price: String = ""
    var dataProcess = DataProcess()
   
    var dataArray = [String:Any]()
    var frame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    func showData (_ : NSNotification) {
        if dataArray.isEmpty {
           dataArray = dataProcess.getJson()["data"] as! [String : Any]
        }
        //모델에서 객체로 매핑해서 주는걸로 바꾸기
        productDetail.text = dataArray["product_description"] as? String
        point.text = dataArray["point"] as? String
        deliveryInfo.text = dataArray["delivery_info"] as? String
        deliveryFee.text = dataArray["delivery_fee"] as? String
    }
    func showImage () {
        //image
        let thumbArray = dataArray["thumb_images"] as! [String]
        let detailArray = dataArray["detail_section"] as! [String]
        let imageCache = dataProcess.getDetailImageCache()
        for i in 0..<thumbArray.count {
            let directory = thumbArray[i].components(separatedBy: "/")
            let path = directory[directory.count-1]
            var foodImage = imageCache.image(withIdentifier: path)
            if foodImage == nil{
                self.dataProcess.loadImage(dataArray: dataArray)
                foodImage = imageCache.image(withIdentifier: path)
            }
            self.frame.origin.x = self.topImage.frame.size.width * CGFloat(i) + 100
            self.frame.origin.y = -64
            self.frame.size = self.topImage.frame.size
            self.frame.size.width = 214
            self.topImage.isPagingEnabled = true
            self.topImage.backgroundColor = UIColor.darkGray
            let imageView = UIImageView(frame: self.frame)
            imageView.image = foodImage
            self.topImage.addSubview(imageView)
        }
        self.topImage.contentSize = CGSize(width: self.topImage.frame.size.width * CGFloat(thumbArray.count), height: 1)
        var height: CGFloat = 0.0
        
        for i in 0..<detailArray.count {
            let directory = detailArray[i].components(separatedBy: "/")
            let path = directory[directory.count-1]
            let foodImage = imageCache.image(withIdentifier: path)
            let imageWidth = foodImage?.size.width
            let imageHeight = foodImage?.size.height
            self.frame.size = self.detailImage.frame.size
            let matchedHeight =  self.frame.size.width * imageHeight! / imageWidth!
            //contents mode 찾아보기
            self.detailImage.isScrollEnabled = true
            self.frame.origin.x = 0
            self.frame.origin.y = height
            height += matchedHeight
            self.frame.size.height = matchedHeight
            let imageView = UIImageView(frame: self.frame)
            imageView.image = foodImage
            self.detailImage.addSubview(imageView)
            self.detailImage.contentSize = self.frame.size
        }
        self.detailImage.contentSize = CGSize(width: 1, height: height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        productTitle.text = titleLabel
        productPrice.text = price
        dataProcess.dataRequest(url: detailHash)
        NotificationCenter.default.addObserver(self, selector: #selector(showData), name: NSNotification.Name("dataArray"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showImage), name: NSNotification.Name("dataArray"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  }
