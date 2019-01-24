//
//  CategoriesViewController.swift
//  Todoey
//
//  Created by Sergiu on 23/01/2019.
//  Copyright © 2019 Sergiu. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoriesViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadCategories()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if let textField = alert.textFields?[0] {
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.hexColor = UIColor.randomFlat.hexValue()
                
                self.save(category: newCategory)
            }
            
        }
        
        alert.addAction(action)
        alert.addTextField { (textField) in
            textField.placeholder = "Insert category name"
        }
        
        self.present(alert, animated: true) {
            self.tableView.reloadData()
        }
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            let color = UIColor(hexString: category.hexColor ?? UIColor.randomFlat.hexValue())
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color!, returnFlat: true)
        }
        else {
            cell.textLabel?.text = "No categories added yet"
        }
        
        return cell
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data manipulation methods
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch {
            print("Error writing using realm: \(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK: - Delete data from swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let category = categories?[indexPath.row] {
            
            do {
                try realm.write {
                    realm.delete(category)
                }
            }
            catch {
                print("Error deleting category: \(error)")
            }
            
        }
        
    }
}
