//
//  myRecipeTableViewCell.swift
//  myRecipes
//
//  Created by Sebastian Banks on 4/28/22.
//

import UIKit

class myRecipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    

    var recipe: Recipe? {
        didSet {
            updateViewCell()
        }
    }

    func updateViewCell() {
        guard let recipe = recipe else { return }
        
        recipeNameLabel.text = recipe.name
        if recipe.recipeImage != nil {
            recipeImage.image = recipe.recipeImage
        } else {
            recipeImage.image = UIImage(systemName: "photo.artframe")
        }
        
    }
    
}
