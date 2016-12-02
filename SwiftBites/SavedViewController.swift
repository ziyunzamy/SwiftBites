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
        savedVideos = fetchVideo()
        self.savedVideosTableView?.reloadData()

        // Do any additional setup after loading the view.
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
        return (savedVideos?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedVideoCell", for: indexPath as IndexPath) as! SavedVideoTableViewCell
        var video:Video = self.videoForRowAtIndexPath(indexPath: indexPath as NSIndexPath)
        cell.name.text = video.name
        cell.backgroundColor = UIColor.white
        let url = NSURL(string: video.thumbnail)!
        let data = NSData(contentsOf: url as URL)! //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        var image = UIImage(data: data as Data)
        cell.thumbnail.image = image
        return cell
    }


    /*
     coredata fetch the saved videos
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
