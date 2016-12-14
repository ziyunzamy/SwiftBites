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
    //video player
    @IBOutlet weak var video: YTPlayerView!
    //video name label
    @IBOutlet weak var videoName: UILabel!
    //save button
    @IBOutlet weak var save: UIButton!
    //tableview for ingredients
    @IBOutlet weak var tableView: UITableView!
    //error if no internet connection
    @IBOutlet weak var error: UILabel!
    //error if no internet connection
    @IBOutlet weak var noIngredients: UILabel!
    //error if no internet connection
    @IBOutlet weak var youtubeImage: UIImageView!
    //email button
    @IBOutlet weak var email: UIButton!
    
    var viewModel: VideoDetailViewModel?
    //###savedVideo related properties###
    //-identidy if the video exist in coredata in order to determine the button image
    var videoSaved: Bool=false
    //-NSManagedObject to ease the process of change
    var videoFromCoredata:NSManagedObject?
    @IBOutlet weak var shop: UIButton!
    //###saved recipe related properties###
    //-identidy if the recipe exist in coredata in order to determine the button image
    var recipeSaved: Bool=false
    //-NSManagedObject to ease the process of change
    var recipeFromCoredata:NSManagedObject?
    override func viewDidLoad() {
        super.viewDidLoad()
        videoName.font = UIFont (name: "Avenir-heavy", size: 17)
        noIngredients.font = UIFont (name: "Avenir", size: 17)
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel?.numberOfIngredients())!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        cell.textLabel?.text = viewModel?.titleForRowAtIndexPath(indexPath: indexPath as NSIndexPath)
        cell.textLabel?.font = UIFont (name: "Avenir", size: 17)
        return cell
    }


    /*
     ####CoreDataRelated Methods###
    */
    /*
    MARK: check with coredata if this video exist in SavedVideos
     */
    func videoIsSaved() -> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // create an instance of our managedObjectContext
        let moc = appDelegate.managedObjectContext
        let request: NSFetchRequest<NSFetchRequestResult> = SavedVideo.fetchRequest()
        let name = viewModel?.name()
        request.predicate = NSPredicate(format: "name == %@", name!)
        do {
            let request = try moc.fetch(request) as! [SavedVideo]
            //if exists, set the video to the CoreData result
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
    /*
     MARK: check with coredata if this recipe exist in SavedRecipe
     */
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
    
    
    /*
     MARK: Method to control the toggle of the save and unsave button
     */
    @IBAction func saveButtonOnClick(){
        //if video already exist in coredata
        if (self.videoSaved){
            //remove it from CoreData
            deleteVideo()
            //change the button image unsaved
            save.setImage(UIImage(named: "save"), for: UIControlState.normal)
            self.videoFromCoredata = nil
            self.videoSaved = false
        }
        //video does not exist in coredata
        else{
            //add it to CoreData
            self.saveVideo()
            //change the button image to saved
            save.setImage(UIImage(named: "saved"), for: UIControlState.normal)
            self.videoSaved = true
        }
    }
    /*
     MARK: remove this video from CoreData SavedVideo list
     */
    func deleteVideo(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let moc = appDelegate.managedObjectContext
        moc.delete(self.videoFromCoredata!)
        do {try moc.save()}
        catch{
            fatalError("Unresolved error \(error)")
        }
    }/*
     MARK: add this video to CoreData SavedVideos
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
        self.videoFromCoredata = entity
        
        // we save our entity
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    /*
     MARK: Method to control the toggle of the shop and unshop button
     */
    @IBAction func shopButtonOnClick(){
        //if this recipe exist in CoreData
        if (self.recipeSaved){
            //remove it from CoreData
            deleteRecipe()
            //change the button image to not added
            shop.setImage(UIImage(named: "add-to-list.png"), for: UIControlState.normal)
            self.recipeFromCoredata = nil
            self.recipeSaved = false
        }
        // this recipe does not exist in CoreData
        else{
            //add it to CoreData
            self.saveRecipe()
            //change the button image to added
            shop.setImage(UIImage(named: "added.png"), for: UIControlState.normal)
            self.recipeSaved = true
        }
    }
    /*
     MARK: remove this ingredient list from CoreData SavedRecipes list
     */
    func deleteRecipe(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let moc = appDelegate.managedObjectContext
        moc.delete(self.recipeFromCoredata!)
        do {try moc.save()}
        catch{
            fatalError("Unresolved error \(error)")
        }
    }
    /*
     MARK: save this ingredient list to CoreData SavedRecipes list
     */
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
    /*
     MARK: initialize the mailer for the email feature
     */
    @IBAction func sendEmailButtonTapped() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    /*
     MARK: build the email body and return it to the mailer
     */
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        if let name = viewModel?.name(),
                let id = viewModel?.videoId(){
            print(id)
            mailComposerVC.setSubject("Recipe for \(name)")
            mailComposerVC.setMessageBody("<h4>Hey, just want you to checkout this awesome Tasty Video <a href='https://www.youtube.com/watch?v=\(id)'>\(name)</a>. Let's make sure we have all these ingredients so that we can cook it later!</h4>\(self.buildEmailIngredientList())", isHTML: true)
        }
        
        return mailComposerVC
    }
    /*
     MARK: build the html version of the ingredient list, the <ul><li> format
    */
    func buildEmailIngredientList() -> String {
        var result = "<ul>"
        print(viewModel?.getIngredients())
        for obj in (viewModel?.getIngredients())!{
            result.append("<li>\(obj.key)</li>")
        }
        result.append("</ul>")
        return result
    }
    /*
     MARK: show alert when there is error sending the email
     */
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    /*
     MARK: required by MFMailComposeViewControllerDelegate
     */
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
