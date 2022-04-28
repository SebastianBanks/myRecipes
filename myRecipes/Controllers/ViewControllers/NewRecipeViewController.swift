//
//  NewRecipeViewController.swift
//  myRecipes
//
//  Created by Sebastian Banks on 4/22/22.
//

import UIKit

class NewRecipeViewController: UIViewController {
    
    @IBOutlet weak var photoContainerView: UIView!
    @IBOutlet weak var recipeNameTextField: UITextField!
    @IBOutlet weak var ingredientsTextField: UITextField!
    @IBOutlet weak var directionsTextField: UITextField!
    @IBOutlet weak var createRecipeButton: UIButton!
    
    
    var recipeImage: UIImage?
    var recipe: Recipe?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    @IBAction func createRecipeButtonTapped(_ sender: Any) {
        
        guard let recipeName = recipeNameTextField.text, !recipeName.isEmpty,
              let ingredients = ingredientsTextField.text, !ingredients.isEmpty,
              let directions = directionsTextField.text, !directions.isEmpty
        else { return }
        
        let ingredientsArray = ingredients.convertToRecipeFormat()
        let directionsArray = directions.convertToRecipeFormat()
        
        if let recipe = recipe {
            recipe.name = recipeName
            recipe.ingredients = ingredientsArray
            recipe.directions = directionsArray
            recipe.recipeImage = recipeImage
            
            RecipeController.shared.updateRecipe(recipe) { success in
                if success {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            RecipeController.shared.saveRecipe(with: recipeName, ingredients: ingredientsArray, directions: directionsArray, image: recipeImage) { success in
                if success {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func setupViews() {
        if let recipe = recipe {
            recipeNameTextField.text = recipe.name
            ingredientsTextField.text = recipe.ingredients.convertToEditFormat()
            directionsTextField.text = recipe.directions.convertToEditFormat()
            createRecipeButton.setTitle("Update Recipe", for: .normal)
            recipeImage = recipe.recipeImage
        } else {
            createRecipeButton.setTitle("Create Recipe", for: .normal)
        }
        
        photoContainerView.layer.cornerRadius = photoContainerView.frame.height / 5
        photoContainerView.clipsToBounds = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoPickerVC" {
            let destinationVC = segue.destination as? PhotoPickerViewController
            destinationVC?.delegate = self
        }
    }

}

extension NewRecipeViewController: PhotoPickerDelegate {
    func photoPickerSelected(image: UIImage) {
        self.recipeImage = image
    }
    
}
