//
//  ShoppingListTableViewController.swift
//  myRecipes
//
//  Created by Sebastian Banks on 4/22/22.
//

import UIKit

class ShoppingListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ShoppingListController.shared.fetchItems { success in
            if success {
                self.updateView()
            }
        }
    }
    
    @IBAction func isMarkedButtonPressed(_ sender: Any) {
        print("pressed")
        updateView()
    }
    
    @IBAction func addItemButtonPressed(_ sender: Any) {
        presentItemAlert(nil)
    }
    

    // MARK: - Table view data source
    
    func updateView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func presentItemAlert(_ item: ShoppingListItem?) {
        let alertTitle = item != nil ? "Update Item" : "Add New Item"
        let alertMessage = item != nil ? "Update the item below" : "Add a new item below"
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "amount"
            textField.autocorrectionType = .yes
            textField.autocapitalizationType = .words
            if let item = item {
                textField.text = item.amount
            }
        }
        
        alert.addTextField { textField in
            textField.placeholder = "item name"
            textField.autocorrectionType = .yes
            textField.autocapitalizationType = .words
            if let item = item {
                textField.text = item.name
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let addItemAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let amount = alert.textFields?.first?.text, !amount.isEmpty else { return }
            guard let name = alert.textFields?.last?.text, !name.isEmpty else { return }
            
            if let item = item {
                item.amount = amount
                item.name = name
                ShoppingListController.shared.update(item) { success in
                    if success {
                        self.updateView()
                    }
                }
            } else {
                ShoppingListController.shared.saveItem(with: name, amount: amount) { success in
                    self.updateView()
                }
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addItemAction)
        
        self.present(alert, animated: true)
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ShoppingListController.shared.items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ShoppingListItemTableViewCell else { return UITableViewCell() }
        
        let item = ShoppingListController.shared.items[indexPath.row]
        cell.item = item

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = ShoppingListController.shared.items[indexPath.row]
        presentItemAlert(selectedItem)
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemToDelete = ShoppingListController.shared.items[indexPath.row]
            guard let index = ShoppingListController.shared.items.firstIndex(of: itemToDelete) else { return }
            print("yes")
            ShoppingListController.shared.delete(itemToDelete) { success in
                if success {
                    print("successfully deleted")
                    ShoppingListController.shared.items.remove(at: index)
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        
                    }
                } else {
                    print("could not delete item")
                }
            }
        }
    }

}
