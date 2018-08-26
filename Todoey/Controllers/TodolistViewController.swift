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

class TodolistViewController: UITableViewController {

    
    //let defaults = UserDefaults.standard
    
    var itemArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            
            self.itemArray.append(Item(thetitle: userTextField.text!))
            
//            self.itemArray.append(userTextField.text!)
//
//            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            //print("Reloading")
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
        
       // item.done = !item.done
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        tableView.reloadData()
       tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
}

