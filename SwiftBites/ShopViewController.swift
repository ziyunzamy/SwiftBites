//
//  ShopViewController.swift
//  SwiftBites
//
//  Created by Ziyun Zheng on 11/7/16.
//  Copyright © 2016 Ziyun Zheng. All rights reserved.
//  ideas & code snippets partially taken from "https://github.com/jeantimex/ios-swift-collapsible-table-section"
//

import UIKit
import CoreData
class ShopViewController: UITableViewController {
    var savedRecipes: [SavedRecipe] = []
    var recipes: [Recipe] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Shoppinglist"
        savedRecipes = fetchRecipe()!
        recipes = savedRecipeToRecipe()
        self.tableView.reloadData()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        savedRecipes = fetchRecipe()!
        recipes = savedRecipeToRecipe()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func numberOfSections(in: UITableView) -> Int{
        return self.recipes.count
    }
    //cell
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (recipes[section].ingredients.count)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell") as! ingredientCell? ?? ingredientCell(style: .default, reuseIdentifier: "ingredientCell")
        let ingredients = recipes[indexPath.section].ingredients
        let keys = [String](ingredients.keys)
        cell.ingredient.text = keys[indexPath.row]
        if(ingredients[keys[indexPath.row]])!{
            cell.setChecked()
        }
        else{
            cell.setUnchecked()
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return recipes[indexPath.section].collapsed ? 0 : 44.0
    }

    // Header
   override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        header.titleLabel.text = recipes[section].name
        header.arrowLabel.text = ">"
        header.setCollapsed(collapsed: recipes[section].collapsed)
        
        header.section = section
        header.delegate = self
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    
//    func saveVideo() {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        // create an instance of our managedObjectContext
//        let moc = appDelegate.managedObjectContext
//        
//        // we set up our entity by selecting the entity and context that we're targeting
//        let entity = NSEntityDescription.insertNewObject(forEntityName: "SavedVideo", into: moc) as! SavedVideo
//        
//        // add our data
//        entity.setValue(viewModel?.videoId(), forKey: "videoId")
//        entity.setValue(viewModel?.name(), forKey: "name")
//        entity.setValue(viewModel?.thumbnail(), forKey: "thumbnail")
//        self.videoFromCoredata = entity
//        
//        // we save our entity
//        do {
//            try moc.save()
//        } catch {
//            fatalError("Failure to save context: \(error)")
//        }
//    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let moc = appDelegate.managedObjectContext
        let section = indexPath.section
        let index = indexPath.row
        let ingredients = recipes[section].ingredients
        let keys = [String](ingredients.keys)
        let cell = tableView.cellForRow(at: indexPath) as! ingredientCell
        let checked = ingredients[keys[index]]!
        let request: NSFetchRequest<NSFetchRequestResult> = SavedRecipe.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", recipes[section].name)
        do {
            let request = try moc.fetch(request) as! [SavedRecipe]
            var managedObject = request[0]
            if(checked){
                cell.setUnchecked()
                recipes[section].ingredients[keys[index]] = !checked
                savedRecipes[section].ingredients?[keys[index]] = !checked
                managedObject.setValue(savedRecipes[section].ingredients,forKey:"ingredients")                
                do {
                    try moc.save()
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
                
            }
            else{
                cell.setChecked()
                recipes[section].ingredients[keys[index]] = !checked
                savedRecipes[section].ingredients?[keys[index]] = !checked
                managedObject.setValue(savedRecipes[section].ingredients,forKey:"ingredients")
                do {
                    try moc.save()
                } catch {
                    fatalError("Failure to save context: \(error)")
                }

            }
        } catch {
            fatalError("Failed to fetch video: \(error)")
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
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
            let recipe:Recipe = Recipe(videoId:"",name: "",ingredients: [:],
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
        //opposite of the original collapsed value
        let collapsed = !recipes[section].collapsed
        
        // Toggle collapse
        recipes[section].collapsed = collapsed
        header.setCollapsed(collapsed: collapsed)
        
        // Adjust the height of the rows inside the section
        self.tableView.beginUpdates()
        for i in 0 ..< recipes[section].ingredients.count {
            let path = NSIndexPath.init(row: i, section: section)
            self.tableView.reloadRows(at: [path as IndexPath],with: .automatic)
        }
        self.tableView.endUpdates()
    }
    
}
