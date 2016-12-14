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
        navigationItem.title = "Shopping List"
        savedRecipes = fetchRecipe()!
        recipes = savedRecipeToRecipe()
        self.tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        savedRecipes = fetchRecipe()!
        recipes = savedRecipeToRecipe()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    /**
     number of sections represent the number saved shopping list recipes
     */
    override func numberOfSections(in: UITableView) -> Int{
        if self.recipes.count > 0 {
            self.tableView.backgroundView?.isHidden = true
            self.tableView.separatorStyle = .singleLine
            return self.recipes.count
        }
        else {
            let messageLabel = UILabel(frame: CGRect(x: 0,y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            messageLabel.text = "No ingredients in shopping list. Add a recipe to your shopping list from a recipe detail page."
            messageLabel.textColor = UIColor.black
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.sizeToFit();
            self.tableView.backgroundView = messageLabel;
            self.tableView.separatorStyle = .none;
            return 0
        }
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

    /**
     MARK: build the header of each section, as in each saved recipe
     */
   override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        //set title to the name of the recipe
        header.titleLabel.text = recipes[section].name
        //set the arrow to identify the collapse/uncollapse status
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let moc = appDelegate.managedObjectContext
        //section identifies which recipe
        let section = indexPath.section
        //row identifies which ingredient in the selected recipe
        let index = indexPath.row
        //ingredient is a NSDictionary with for mat of String:Bool
        //  with String represent each ingredient and Bool represent if it is checked or not
        let ingredients = recipes[section].ingredients
        // keys represent all the ingredident strings
        let keys = [String](ingredients.keys)
        let cell = tableView.cellForRow(at: indexPath) as! ingredientCell
        let checked = ingredients[keys[index]]!
        let request: NSFetchRequest<NSFetchRequestResult> = SavedRecipe.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", recipes[section].name)
        //fetch the recipe list to show the check/uncheck state for each ingredient
        do {
            let request = try moc.fetch(request) as! [SavedRecipe]
            let managedObject = request[0]
            if(checked){
                //toggle to uncheck
                cell.setUnchecked()
                //save the changes to CoreData
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
                //toggle to checked
                cell.setChecked()
                //save the changes to CoreData
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
    // MARK: - Coredata-fetch SavedRecipes from CoreData
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
    /*
     // MARK: - Turn NSManagedObject to normal struct
     */
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
