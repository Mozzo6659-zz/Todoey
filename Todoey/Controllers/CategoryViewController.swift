//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mick Mossman on 27/8/18.
//  Copyright © 2018 Mick Mossman. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }

    @IBAction func addCategory(_ sender: UIBarButtonItem) {
    
    //MARK: - Tableview Datasource methods
    var userTextField = UITextField() //module lel textfile used in the closure
    
    let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
    
    let alertAction = UIAlertAction(title: "Add Category", style: .default) {
        (action) in
        
        //var item = Item(thetitle: userTextField.text!)
        
        
        let newItem = Category(context: self.context)
        newItem.name = userTextField.text!
        
        //self.itemArray.append(Item(thetitle: userTextField.text!))
        
        //            self.itemArray.append(userTextField.text!)
        //
        //            self.defaults.set(self.itemArray, forKey: "TodoListArray")
       
        self.saveData()
        self.loadCategories()
       
        
    }
    
    alert.addTextField { (alertTextField) in
    alertTextField.placeholder = "Create New Item"
    userTextField = alertTextField
    }
    
    alert.addAction(alertAction)
    present(alert, animated: true, completion: nil)
}

    //MARK: - Tableview Delegate methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
   
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        //cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            
            if let indexpath = tableView.indexPathForSelectedRow {
                let vc = segue.destination as! TodolistViewController
                vc.selectedCategory = categoryArray[indexpath.row]
            }
            
            
        }
    }
    //MARK: - Data manipulation methods
    
    
    func saveData() {
        
        
        do {
            try context.save()
        }catch {
            print("Error encoding Item array")
        }
        tableView.reloadData()
    }
    
    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
        }catch {
            print("error on fetch \(error)")
        }
        
       tableView.reloadData()
        
        
    }
}
