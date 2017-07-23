//
//  ViewController.swift
//  ConvertPhoto
//
//  Created by woowabrothers on 2017. 7. 23..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var collection: UICollectionView!
    @IBAction func makeMovie(_ sender: Any) { 
        let items = collection.indexPathsForSelectedItems
        selectedImages.removeAll()
        for i in items! {
            let cell = collection.cellForItem(at: i) as! CollectionViewCell
            selectedImages.append(cell.image.image!)
        }
        let settings = RenderSettings()
        let imageAnimator = ImageAnimator(renderSettings: settings)
        imageAnimator.images = selectedImages
        imageAnimator.render()
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: settings.outputURL as URL)
        }, completionHandler: { success, error in
            if success {
                print("success")
                // Saved successfully!
            }
            else {
                print("failed")
                // Save photo failed
            }
        })
    }
    var images = [UIImage]()
    var selectedImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collection.dataSource = self
        collection.delegate = self
        collection.allowsMultipleSelection = true
        images = Photo().getPhotos()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell {
            cell.image.image = images[indexPath.item]
            return cell
        }
        return CollectionViewCell()
    }
}
extension ViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.isSelected = true
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.isSelected = false
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
