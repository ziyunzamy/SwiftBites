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
import MessageUI
class VideoDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,MFMailComposeViewControllerDelegate{
    @IBOutlet weak var back: UIButton!

    @IBOutlet weak var video: YTPlayerView!
    @IBOutlet weak var videoName: UILabel!
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var error: UILabel!
    @IBOutlet weak var noIngredients: UILabel!
    @IBOutlet weak var youtubeImage: UIImageView!
    var viewModel: VideoDetailViewModel?
    //savedVideo related properties
    var videoSaved: Bool=false
    var videoFromCoredata:NSManagedObject?
    @IBOutlet weak var shop: UIButton!
    //saved recipe related properties
    var recipeSaved: Bool=false
    var recipeFromCoredata:NSManagedObject?
    override func viewDidLoad() {
        super.viewDidLoad()
        //check if this video is saved
        if(videoIsSaved()){
            save.setImage(UIImage(named: "saved"), for: UIControlState.normal)
            self.videoSaved = true
        }
        if(recipeIsSaved()){
            shop.setImage(UIImage(named: "added"), for: UIControlState.normal)
            self.recipeSaved = true
        }
        let status = Reach().connectionStatus()
        switch status {
            case .unknown, .offline:
                error.text = "Cannot load video due to lack of internet connection."
                noIngredients.text = "No connection. Add recipe to shopping list to view ingredients list."
                youtubeImage.image = UIImage(named: "youtube-error")
            case .online(.wwan), .online(.wiFi):
                video.load(withVideoId: (viewModel?.videoId())!, playerVars: ["playsinline": "1", "loop": "1"])
                viewModel?.refresh { [unowned self] in
                    DispatchQueue.main.async {
                        self.tableView?.reloadData()
                    }
                }
        }
        videoName.text = viewModel?.name()?.uppercased()
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


    /*
     CoreDataStack
    */
    
    //check with coredata if this video object exists, will only run once at viewDidLoad()
    func videoIsSaved() -> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // create an instance of our managedObjectContext
        let moc = appDelegate.managedObjectContext
        let request: NSFetchRequest<NSFetchRequestResult> = SavedVideo.fetchRequest()
        let name = viewModel?.name()
        request.predicate = NSPredicate(format: "name == %@", name!)
        do {
            let request = try moc.fetch(request) as! [SavedVideo]
            if (request.count > 0){
                videoFromCoredata = request[0]
                return true
            }
            else{
                return false
            }
        } catch {
            fatalError("Failed to fetch video: \(error)")
        }
    }
    //check with coredata if recipe robject exists, will only run once at viewDidLoad()
    func recipeIsSaved() -> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // create an instance of our managedObjectContext
        let moc = appDelegate.managedObjectContext
        let request: NSFetchRequest<NSFetchRequestResult> = SavedRecipe.fetchRequest()
        let name = viewModel?.name()
        request.predicate = NSPredicate(format: "name == %@", name!)
        do {
            let request = try moc.fetch(request) as! [SavedRecipe]
            if (request.count > 0){
                self.recipeFromCoredata = request[0]
                return true
            }
            else{
                return false
            }
        } catch {
            fatalError("Failed to fetch video: \(error)")
        }
    }
    
    
    
    //toggle save and unsave for videos
    @IBAction func saveButtonOnClick(){
        if (self.videoSaved){
            deleteVideo()
            save.setImage(UIImage(named: "save"), for: UIControlState.normal)
            self.videoFromCoredata = nil
            self.videoSaved = false
        }
        else{
            self.saveVideo()
            save.setImage(UIImage(named: "saved"), for: UIControlState.normal)
            self.videoSaved = true
        }
        sendEmailButtonTapped(sender: self)
    }
    func deleteVideo(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let moc = appDelegate.managedObjectContext
        moc.delete(self.videoFromCoredata!)
        do {try moc.save()}
        catch{
            fatalError("Unresolved error \(error)")
        }
    }
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
        self.videoFromCoredata = entity
        
        // we save our entity
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    //toggle save and unsave for recipes
    @IBAction func shopButtonOnClick(){
        if (self.recipeSaved){
            deleteRecipe()
            shop.setImage(UIImage(named: "add-to-list.png"), for: UIControlState.normal)
            self.recipeFromCoredata = nil
            self.recipeSaved = false
        }
        else{
            self.saveRecipe()
            shop.setImage(UIImage(named: "added.png"), for: UIControlState.normal)
            self.recipeSaved = true
        }
    }
    func deleteRecipe(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let moc = appDelegate.managedObjectContext
        moc.delete(self.recipeFromCoredata!)
        do {try moc.save()}
        catch{
            fatalError("Unresolved error \(error)")
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
        self.recipeFromCoredata = entity
        // we save our entity
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    //MARK email feature
    func sendEmailButtonTapped(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        if let name = viewModel?.name(),
                let id = viewModel?.videoId(){
            print(id)
            mailComposerVC.setSubject("Recipe for \(name)")
            mailComposerVC.setMessageBody("<h4>Hey, just want you to checkout this awesome Tasty Video <a href='https://www.youtube.com/watch?v=\(id)'>\(name)</a>. Let's make sure we have all these ingredients so that we can cook it later!</h4>\(self.buildEmailBody())", isHTML: true)
        }
        
        return mailComposerVC
    }
    func buildEmailBody() -> String {
        var result = "<ul>"
        print(viewModel?.getIngredients())
        for obj in (viewModel?.getIngredients())!{
            result.append("<li>\(obj.key)</li>")
        }
        result.append("</ul>")
        return result
    }
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
