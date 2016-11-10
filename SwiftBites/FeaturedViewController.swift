//
//  FeaturedViewController.swift
//  SwiftBites
//
//  Created by Ziyun Zheng on 11/7/16.
//  Copyright © 2016 Ziyun Zheng. All rights reserved.
//

import UIKit
class FeaturedViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    fileprivate let reuseIdentifier = "YoutubeVideoCell"
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    let viewModel = FeaturedViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.refresh { [unowned self] in
        DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that casn be recreated.
    }

    func videoForIndexPath(indexPath: IndexPath) -> Video {
        return viewModel.videos[(indexPath as NSIndexPath).section]
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.videos.count
    }
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return viewModel.videos.count
    }
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! YoutubeVideoCell
        let video = videoForIndexPath(indexPath: indexPath as IndexPath)
        print(video)
        cell.backgroundColor = UIColor.white
        let url = NSURL(string: video.thumbnail)!
        let data = NSData(contentsOf: url as URL)! //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        var image = UIImage(data: data as Data)
        cell.imageView.image = image
        return cell
    }
    //code for modifying the view from https://www.raywenderlich.com/136159/uicollectionview-tutorial-getting-started
//    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

