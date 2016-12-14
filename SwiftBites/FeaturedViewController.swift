//
//  FeaturedViewController.swift
//  SwiftBites
//
//  Created by Ziyun Zheng on 11/7/16.
//  Copyright © 2016 Ziyun Zheng. All rights reserved.
//
//collection view ideas and code snippets from tutorial https://www.raywenderlich.com/136161/uicollectionview-tutorial-reusable-views-selection-reordering


import UIKit
class FeaturedViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    fileprivate let reuseIdentifier = "YoutubeVideoCell"
    fileprivate let itemsPerRow: CGFloat = 2
    fileprivate let sectionInsets = UIEdgeInsets(top: 4.0, left: 2.0, bottom: 2.0, right: 2.0)
    /**
     identify if this controller is used for search functionality
     */
    var isSearch:Bool?
    /**
     
     gets more YouTube videos once you reach the end of the first page
     - parameter sender: button that click to load more videos
     
     */
    @IBAction func loadMoreVideos(sender: UIButton) {
        let status = Reach().connectionStatus()
        switch status {
            case .unknown, .offline:
                sender.isEnabled = false
            case .online(.wwan), .online(.wiFi):
                if (viewModel.client.pageToken != nil) {
                    viewModel.refresh { [unowned self] in
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                    }
                }
                else {
                    sender.isEnabled = false
            }
            
        }
    }
    
    var viewModel = FeaturedViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        //do not reset the title if the controller is used for search
        if let setTitle = self.isSearch {
            //do not need to set the navigationItem title becasue it is passed in from segue
        }
        else{
            navigationItem.title = "Featured"
        }
        let status = Reach().connectionStatus()
        switch status {
            case .unknown, .offline:
                let alert = UIAlertController(title: "No Internet Connection", message: "This page is not available without a connection, but you can still browse your shopping list and saved recipes.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            case .online(.wwan), .online(.wiFi):
                viewModel.refresh { [unowned self] in
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that casn be recreated.
    }

    func videoForIndexPath(indexPath: IndexPath) -> Video {
        return viewModel.videos[(indexPath as NSIndexPath).row]
    }

    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return viewModel.videos.count
    }
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        //1
        switch kind {
        //2
        case UICollectionElementKindSectionFooter:
            //3
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "LoadMoreFooterView",
                                                                             for: indexPath) as! LoadMoreFooterView
            return footerView
        default:
            //4
            assert(false, "Unexpected element kind")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! YoutubeVideoCell
        let video = videoForIndexPath(indexPath: indexPath as IndexPath)
        cell.backgroundColor = UIColor.white
        let url = NSURL(string: video.thumbnail)!
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            cell.thumbnail.image = UIImage(named: "img-not-avail")
        case .online(.wwan), .online(.wiFi):
            let data = NSData(contentsOf: url as URL)! //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            cell.thumbnail.image = UIImage(data: data as Data)
        }
        return cell
    }
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let status = Reach().connectionStatus()
        /**
         check network status
         */
        switch status {
        case .unknown, .offline:
            let alert = UIAlertController(title: "No Internet Connection", message: "Recipe detail is not available without a connection, but you can still browse your shopping list and saved recipes.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        case .online(.wwan), .online(.wiFi):
            if segue.identifier == "showDetail"{
                if let detailVC = segue.destination as? VideoDetailViewController,
                    let cell = sender as? UICollectionViewCell,
                    let indexPath = collectionView?.indexPath(for: cell) {
                    detailVC.viewModel =  viewModel.detailViewModelForSectionAtIndexPath(indexPath: indexPath as NSIndexPath)
                    detailVC.navigationItem.title = "Recipe Detail"
                    navigationItem.backBarButtonItem?.title = "back"
                }
            }
        }
    }
}

