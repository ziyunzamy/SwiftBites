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
    var savedRecipes: [SavedRecipe] = []
    var recipes: [Recipe] = []
    fileprivate let reuseIdentifier = "singleShoppinglist"
    @IBOutlet weak var shoppinglistTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Shoppinglist"
        savedRecipes = fetchRecipe()!
        recipes = savedRecipeToRecipe()
        self.shoppinglistTableView?.reloadData()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        savedRecipes = fetchRecipe()!
        self.shoppinglistTableView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return  (self.recipes.count)

    }
    //cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (recipes[section].ingredients.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell? ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = savedRecipes[indexPath.section].ingredients?[indexPath.row]
//        var recipe:Recipe = self.recipeForRowAtIndexPath(indexPath: indexPath as NSIndexPath)
//        cell.textLabel?.text = recipe.name
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return recipes[indexPath.section].collapsed ? 0 : 44.0
    }
    // Header
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        header.titleLabel.text = savedRecipes[section].name
        header.arrowLabel.text = ">"
        header.setCollapsed(collapsed: recipes[section].collapsed)
        
        header.section = section
        header.delegate = self
        
        return header
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    
    func recipeForRowAtIndexPath(indexPath: NSIndexPath) -> Recipe {
        let index = indexPath.row
        if index < (savedRecipes.count) {
            let recipe:Recipe = Recipe(videoId: savedRecipes[index].videoId!,
                                    name: savedRecipes[index].name!,
                                    ingredients: savedRecipes[index].ingredients!,
                                    collapsed:true)
            return recipe
        }
        else{
            let recipe:Recipe = Recipe(videoId:"",name: "",ingredients: [],
                                       collapsed:true)
            return recipe
        }
    }
    /*
    // MARK: - Coredata
    */
    func fetchRecipe()-> [SavedRecipe]? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // create an instance of our managedObjectContext
        let moc = appDelegate.managedObjectContext
        let request: NSFetchRequest<NSFetchRequestResult> = SavedRecipe.fetchRequest()
        
        do {
            let request = try moc.fetch(request) as! [SavedRecipe]
            return request
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
    }
    func savedRecipeToRecipe() -> [Recipe] {
        var result:[Recipe] = []
        for object in self.savedRecipes{
            let recipe:Recipe = Recipe(videoId: object.videoId!,
                                       name: object.name!,
                                       ingredients: object.ingredients!,
                                       collapsed:true)
            result.append(recipe)
        }
        return result
    }

}

//
// MARK: - Section Header Delegate
//
extension ShopViewController: CollapsibleTableViewHeaderDelegate {
    
    func toggleSection(header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !recipes[section].collapsed
        
        // Toggle collapse
        recipes[section].collapsed = collapsed
        header.setCollapsed(collapsed: collapsed)
        
        // Adjust the height of the rows inside the section
        shoppinglistTableView.beginUpdates()
        for i in 0 ..< recipes[section].ingredients.count {
            let path = NSIndexPath.init(row: i, section: section)
            shoppinglistTableView.reloadRows(at: [path as IndexPath],with: .automatic)
        }
        shoppinglistTableView.endUpdates()
    }
    
}
