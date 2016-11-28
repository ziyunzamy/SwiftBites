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
    var savedVideos: [SavedVideo]?
    @IBOutlet weak var savedVideosTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedVideoCell", for: indexPath as IndexPath)
        cell.textLabel?.text = self.videoForRowAtIndexPath(indexPath: indexPath as NSIndexPath)
        return cell
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func fetchVideo() -> [SavedVideo]?{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // create an instance of our managedObjectContext
        let moc = appDelegate.managedObjectContext
        let request: NSFetchRequest<NSFetchRequestResult> = SavedVideo.fetchRequest()
        
        do {
            let request = try moc.fetch(request) as! [SavedVideo]
            print("S********\(request.count)")
            print("S********videoId\(request.first?.videoId)")
            print("S********name\(request.first?.name)")
            print("S********thumbnail\(request.first?.thumbnail)")
            return request
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
    }
    func videoForRowAtIndexPath(indexPath: NSIndexPath) -> String {
        let index = indexPath.row
        if index < (savedVideos?.count)! {
            return savedVideos![index].name!
        }
        return ""
    }

}
