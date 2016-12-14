//
//  SavedViewController.swift
//  SwiftBites
//
//  Created by Ziyun Zheng on 11/7/16.
//  Copyright © 2016 Ziyun Zheng. All rights reserved.
//

import UIKit
import CoreData
class SavedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    fileprivate let reuseIdentifier = "savedVideoCell"
    var savedVideos: [SavedVideo]?
    @IBOutlet weak var savedVideosTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Saved Recipes"
        //fetch saved videos from coredata
        savedVideos = fetchVideo()
        self.savedVideosTableView?.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        savedVideos = fetchVideo()
        self.savedVideosTableView?.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*
         check if there is any saved videos in coredata
         */
        if (savedVideos?.count)! > 0 {
            savedVideosTableView?.backgroundView?.isHidden = true
            savedVideosTableView?.separatorStyle = .singleLine
            return (savedVideos?.count)!
        }
        else {
            let messageLabel = UILabel(frame: CGRect(x: 0,y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            messageLabel.text = "No recipes saved. Add a recipe to your saved list from a recipe detail page."
            messageLabel.textColor = UIColor.black
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.sizeToFit();
            savedVideosTableView?.backgroundView = messageLabel;
            savedVideosTableView?.separatorStyle = .none;
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedVideoCell", for: indexPath as IndexPath) as! SavedVideoTableViewCell
        let video:Video = self.videoForRowAtIndexPath(indexPath: indexPath as NSIndexPath)
        cell.name.text = video.name
        cell.backgroundColor = UIColor.white
        let status = Reach().connectionStatus()
        switch status {
            /*
             Load saved videos from coredata
             */
        case .unknown, .offline:
            print("Not connected")
            cell.thumbnail.image = UIImage(named: "img-not-avail")
        case .online(.wwan), .online(.wiFi):
            let url = NSURL(string: video.thumbnail)!
            let data = NSData(contentsOf: url as URL)! //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            let image = UIImage(data: data as Data)
            cell.thumbnail.image = image
        }
        return cell
    }
    func videoForRowAtIndexPath(indexPath: NSIndexPath) -> Video {
        let index = indexPath.row
        if index < (savedVideos?.count)! {
            let video:Video = Video(videoId: savedVideos![index].videoId!,
                                    name: savedVideos![index].name!,
                                    thumbnail: savedVideos![index].thumbnail!)
            return video
        }
        else{
            let video:Video = Video(videoId:"",name: "",thumbnail: "")
            return video
        }
    }
    func detailViewModelForSectionAtIndexPath(indexPath: NSIndexPath) -> VideoDetailViewModel {
        let result = VideoDetailViewModel(video:videoForRowAtIndexPath(indexPath: indexPath))
        return result
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let status = Reach().connectionStatus()
        /*
         check if there is internet connection
         */
        switch status {
        case .unknown, .offline:
            let alert = UIAlertController(title: "No Internet Connection", message: "Recipe detail is not available without a connection, but you can still browse your shopping list and saved recipes.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        case .online(.wwan), .online(.wiFi):
            if segue.identifier == "showDetailFromSaved"{
                if let detailVC = segue.destination as? VideoDetailViewController,
                    let cell = sender as? UITableViewCell,
                    let indexPath = savedVideosTableView.indexPath(for: cell) {
                    detailVC.viewModel =  self.detailViewModelForSectionAtIndexPath(indexPath: indexPath as NSIndexPath)
                    detailVC.navigationItem.title = "Recipe Detail"
                    navigationItem.backBarButtonItem?.title = "back"
                }
            }
        }
    }
    /*
    MARK: method for fetching the saved videos from core data
     */
    func fetchVideo() -> [SavedVideo]?{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // create an instance of our managedObjectContext
        let moc = appDelegate.managedObjectContext
        let request: NSFetchRequest<NSFetchRequestResult> = SavedVideo.fetchRequest()
        
        do {
            let request = try moc.fetch(request) as! [SavedVideo]
            return request
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
    }

}
