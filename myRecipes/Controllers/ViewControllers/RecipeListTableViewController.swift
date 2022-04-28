//
//  RecipesTableViewController.swift
//  myRecipes
//
//  Created by Sebastian Banks on 4/22/22.
//

import UIKit

class RecipeListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecipeController.shared.recipes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myRecipeCell", for: indexPath) as? myRecipeTableViewCell else { return UITableViewCell() }

        // Configure the cell...
        let recipe = RecipeController.shared.recipes[indexPath.row]
        cell.recipe = recipe
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recipeToDelete = RecipeController.shared.recipes[indexPath.row]
            guard let index = RecipeController.shared.recipes.firstIndex(of: recipeToDelete) else { return }
            print("yes")
            RecipeController.shared.deleteRecipe(recipeToDelete) { success in
                if success {
                    print("successfully deleted")
                    RecipeController.shared.recipes.remove(at: index)
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                } else {
                    print("could not delete item")
                }
            }
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMyRecipeVC",
            let indexPath = tableView.indexPathForSelectedRow,
            let destination = segue.destination as? ScrollViewController {
                let recipe = RecipeController.shared.recipes[indexPath.row]
                destination.recipe = recipe
        }
    }

}
