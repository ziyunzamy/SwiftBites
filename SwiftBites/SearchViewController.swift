//
//  SearchViewController.swift
//  SwiftBites
//
//  Created by Ziyun Zheng on 11/7/16.
//  Copyright © 2016 Ziyun Zheng. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var input: UITextField!
    let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.input.delegate = self
        navigationItem.title = "Search"
        input.attributedPlaceholder = NSAttributedString(string: "Chicken")
        input.borderStyle = UITextBorderStyle.roundedRect
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        input.resignFirstResponder()
        return true
    }
    /*
     // MARK: - pass the data to the FeaturedViewController in order to reuse the collectionView
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "search"{
            if let searchCollection = segue.destination as? FeaturedViewController{
                searchCollection.viewModel.searchTerm = input.text
                if let titleSearchTerm = input.text{
                    searchCollection.navigationItem.title = "Search Results for \(titleSearchTerm)"
                }
                else{
                    searchCollection.navigationItem.title = "Search Results"
                }
                searchCollection.isSearch = true
            }
        }
    }
}

