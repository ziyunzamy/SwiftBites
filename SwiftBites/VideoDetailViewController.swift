//
//  VideoDetailViewController.swift
//  SwiftBites
//
//  Created by Ziyun Zheng on 11/14/16.
//  Copyright © 2016 Ziyun Zheng. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON
import youtube_ios_player_helper
class VideoDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var back: UIButton!

    @IBOutlet weak var video: YTPlayerView!
    @IBOutlet weak var videoName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: VideoDetailViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        video.load(withVideoId: (viewModel?.videoId())!, playerVars: ["playsinline": "1", "loop": "1"])
        videoName.text = viewModel?.name()?.uppercased()
        viewModel?.refresh { [unowned self] in
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel?.numberOfIngredients())!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        cell.textLabel?.text = viewModel?.titleForRowAtIndexPath(indexPath: indexPath as NSIndexPath)
        return cell
    }


    /*CoreDataStack
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func saveVideo() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // create an instance of our managedObjectContext
        let moc = appDelegate.managedObjectContext
        
        // we set up our entity by selecting the entity and context that we're targeting
        let entity = NSEntityDescription.insertNewObject(forEntityName: "SavedVideo", into: moc) as! SavedVideo
        
        // add our data
        entity.setValue(viewModel?.videoId(), forKey: "videoId")
        entity.setValue(viewModel?.name(), forKey: "name")
        entity.setValue(viewModel?.thumbnail(), forKey: "thumbnail")
        
        // we save our entity
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    func saveRecipe() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // create an instance of our managedObjectContext
        let moc = appDelegate.managedObjectContext
        
        // we set up our entity by selecting the entity and context that we're targeting
        let entity = NSEntityDescription.insertNewObject(forEntityName: "SavedRecipe", into: moc) as! SavedRecipe
        
        // add our data
        entity.setValue(viewModel?.videoId(), forKey: "videoId")
        entity.setValue(viewModel?.name(), forKey: "name")
        entity.setValue(viewModel?.ingredients, forKey: "ingredients")
        
        // we save our entity
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    func fetchVideo() {
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
            
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
    }
    func fetchRecipe() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // create an instance of our managedObjectContext
        let moc = appDelegate.managedObjectContext
        let request: NSFetchRequest<NSFetchRequestResult> = SavedRecipe.fetchRequest()
        
        do {
            let request = try moc.fetch(request) as! [SavedRecipe]
            print("S********\(request.count)")
            print("S********videoId\(request.first?.videoId)")
            print("S********name\(request.first?.name)")
            print("S********ingredients\(request.first?.ingredients)")
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
    }
    
}
