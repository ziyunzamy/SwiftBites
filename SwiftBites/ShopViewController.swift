//
//  ShopViewController.swift
//  SwiftBites
//
//  Created by Ziyun Zheng on 11/7/16.
//  Copyright © 2016 Ziyun Zheng. All rights reserved.
//

import UIKit
import CoreData
class ShopViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var savedRecipes: [SavedRecipe]?
    fileprivate let reuseIdentifier = "singleShoppinglist"
    @IBOutlet weak var shoppinglistTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Shoppinglist"
        savedRecipes = fetchRecipe()
        self.shoppinglistTableView?.reloadData()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        savedRecipes = fetchRecipe()
        self.shoppinglistTableView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (savedRecipes?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "singleShoppinglist", for: indexPath as IndexPath) as UITableViewCell
        var recipe:Recipe = self.recipeForRowAtIndexPath(indexPath: indexPath as NSIndexPath)
        cell.textLabel?.text = recipe.name
        return cell
    }
    func recipeForRowAtIndexPath(indexPath: NSIndexPath) -> Recipe {
        let index = indexPath.row
        if index < (savedRecipes?.count)! {
            let recipe:Recipe = Recipe(videoId: savedRecipes![index].videoId!,
                                    name: savedRecipes![index].name!,
                                    ingredients: savedRecipes![index].ingredients!)
            return recipe
        }
        else{
            let recipe:Recipe = Recipe(videoId:"",name: "",ingredients: [])
            return recipe
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func fetchRecipe()-> [SavedRecipe]? {
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
            return request
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
    }

}
