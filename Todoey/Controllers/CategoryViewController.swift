//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mick Mossman on 27/8/18.
//  Copyright © 2018 Mick Mossman. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {

    
    
    let realm = try! Realm()
    
    var categoryArray : Results<Category>? //dont force unwrap (!)
    
    //var categoryArray = [Category]()
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        
        //Coredata way
        //let category = Category(context: self.context)
        //category.name = userTextField.text!
        
        //Realm
        let category = Category()
        category.name = userTextField.text!
        
        //using array of obects
        //self.itemArray.append(Item(thetitle: userTextField.text!))
        
        //            self.itemArray.append(userTextField.text!)
        //
        //            self.defaults.set(self.itemArray, forKey: "TodoListArray")
       
        self.saveData(cat: category)
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
        return categoryArray?.count ?? 1 //if its nil then return 1
        //?? is the Nil coalescing operator
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
   
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No cats entered"
        
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
                vc.selectedCategory = categoryArray?[indexpath.row]
            }
            
            
        }
    }
    //MARK: - Data manipulation methods
    
    
    func saveData(cat:Category) {
        
        
        do {
            //try context.save()
            try realm.write {
                realm.add(cat)
            }
        }catch {
            print("Error encoding Item array")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
//    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
//
//        do {
//            categoryArray = try context.fetch(request)
//        }catch {
//            print("error on fetch \(error)")
//        }
//
//       tableView.reloadData()
//
//
//    }
}
