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
    //TODO:replace results to properties from viewModel
    var results = [Video]()
    var video1 = Video()
    var video2 = Video()
    var video3 = Video()
    override func viewDidLoad() {
        super.viewDidLoad()
        results.append(video1)
        results.append(video2)
        results.append(video3)
        //var parser = Parser()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func videoForIndexPath(indexPath: IndexPath) -> Video {
        return results[(indexPath as NSIndexPath).section]
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("*****************")
        print(results.count)
        return results.count
    }
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! YoutubeVideoCell
        cell.backgroundColor = UIColor.black
//        let video = videoForIndexPath(indexPath: indexPath as IndexPath)
//        cell.backgroundColor = UIColor.white
//        //3
//        cell.imageView.image = NSURL(string: video.thumbnail)
//            .flatMap { NSData(contentsOf: $0 as URL) }
//            .flatMap { UIImage(data: $0 as Data) }
        return cell
    }
    //code for modifying the view from https://www.raywenderlich.com/136159/uicollectionview-tutorial-getting-started
    
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

