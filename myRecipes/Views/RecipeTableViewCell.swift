//
//  RecipeTableViewCell.swift
//  myRecipes
//
//  Created by Sebastian Banks on 4/22/22.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    
    
    var recipe: SpoonacularRecipe? {
        didSet {
            updateViewCell()
        }
    }

    func updateViewCell() {
        guard let recipe = recipe else { return }
        
        recipeNameLabel.text = recipe.title
        fetchRecipeImage(recipe: recipe)
        
    }
    
    func fetchRecipeImage(recipe: SpoonacularRecipe) {
        
        SpoonacularController.fetchImage(with: recipe.image) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.recipeImage.image = image
                case .failure(let error):
                    self.recipeImage.image = UIImage(systemName: "photo.artframe")
                    print("error loding image: \(error)")
                }
            }
        }
    }
    
}
