//
//  ViewController.swift
//  Todoey
//
//  Created by Mick Mossman on 24/8/18.
//  Copyright © 2018 Mick Mossman. All rights reserved.
//
//This runs really slow n the cimulate and a"Unable to nsert copy_send" error appears
//it works on a device
import UIKit
import CoreData

class TodolistViewController: UITableViewController {

    
    //let defaults = UserDefaults.standard
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    var itemArray = [Item]()
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        //loadItems()
        
        //var item = Item("")
        
        // Do any additional setup after loading the view, typically from a nib.
//        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
//            itemArray = items
//
//        }
    }

    
    
    //MARK - Add new ietms
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        var userTextField = UITextField() //module lel textfile used in the closure
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add Item", style: .default) {
            (action) in
            
            //var item = Item(thetitle: userTextField.text!)
            
            
            let newItem = Item(context: self.context)
            newItem.title = userTextField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            //self.itemArray.append(Item(thetitle: userTextField.text!))
            
            //            self.itemArray.append(userTextField.text!)
            //
            //            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            print("Reloading")
            self.saveData()
            self.loadItems()
            self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            userTextField = alertTextField
        }
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Tableview shite
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    //MARK - Tableview delegate methinds
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
       itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //DELETION
        //context.delete(itemArray[indexPath.row]) do this one first duh
        //itemArray.remove(at: indexPath.row)
        //END DELETION
        
       // item.done = !item.done
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        saveData()
        
       tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    func saveData() {
        
        
        do {
            try context.save()
        }catch {
            print("Error encoding Item array")
        }
        tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest()) {
        
        
        let pred = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if request.predicate != nil {
            let compound:NSCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [request.predicate!,pred])
            request.predicate = compound
        }else{
            request.predicate = pred
        }
        
        
        do {
            itemArray = try context.fetch(request)
        }catch {
            print("error on fetch \(error)")
        }
        
        
        
        
    }
}

extension TodolistViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //google NSpredicate cheatsheet
        //[cd] case and diacritic insensitive
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors?.append(NSSortDescriptor(key: "title", ascending: false))
        
        loadItems(with: request)

        tableView.reloadData()
         searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadItems()
            
            tableView.reloadData()
            
            DispatchQueue.main.async {
                 searchBar.resignFirstResponder()
            }
           
        }
    }
}
