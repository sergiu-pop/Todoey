//
//  CategoriesViewController.swift
//  Todoey
//
//  Created by Sergiu on 23/01/2019.
//  Copyright © 2019 Sergiu. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoriesViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 78.0
        self.loadCategories()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if let textField = alert.textFields?[0] {
                let newCategory = Category()
                newCategory.name = textField.text!
                
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        
        cell.delegate = self
        
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
}

//MARK: - SwipeCell delegate methods

extension CategoriesViewController : SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            do {
                try self.realm.write {
                    if let category = self.categories?[indexPath.row] {
                        self.realm.delete(category)
                    }
                }
                self.loadCategories()
            }
            catch {
                print("Error deleting category from realm: \(error)")
            }
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "trash-icon")
        
        return [deleteAction]
    }
    
    
}
