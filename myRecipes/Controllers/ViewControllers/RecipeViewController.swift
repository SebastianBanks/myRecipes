//
//  RecipeViewController.swift
//  myRecipes
//
//  Created by Sebastian Banks on 4/22/22.
//

import UIKit

class RecipeViewController: UIViewController {
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var directionsLabel: UILabel!
    @IBOutlet weak var recipeTitle: UINavigationItem!
    
    
    var recipe: SpoonacularRecipe?
    var recipeImageFetched: UIImage?
    var ingredients: [String] = []
    var directions: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientsLabel.text = ""
        directionsLabel.text = ""
        setupView()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let recipe = recipe else { return }
        guard !ingredients.isEmpty else { return }
        guard !directions.isEmpty else { return }
        
        if recipeImageFetched == nil {
            recipeImageFetched = UIImage(named: "cat")
        }
        

        RecipeController.shared.saveRecipe(with: recipe.title, ingredients: ingredients, directions: directions, image: recipeImageFetched) { success in
            switch success {
            case true:
                print("saved successfully")
                print(RecipeController.shared.recipes)
            case false:
                print("error saving recipe")
            }
        }
    }
    
    
    func printValues() {
        print(self.ingredients)
        print(self.directions)
    }
    
    func setupView() {
        print("trying to setup")
        guard let recipe = recipe else { return }
        print("setting up view")
        
        recipeTitle.title = recipe.title
        
        
        SpoonacularController.fetchRecipeDirections(id: recipe.id) { result in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let directions):
                    for step in directions.steps {
                        
                        self.directions.append("\(step.number). \(step.step)")
                    }
                    
                    for step in self.directions {
                        self.directionsLabel.text?.append("\(step)\n")
                    }
                    
                case .failure(let error):
                    print("Error fetching directions: \(error.localizedDescription)")
                }
            }
            
        }
        
        SpoonacularController.fetchRecipeIngredients(id: recipe.id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let ingredients):
                    for ingredient in ingredients.ingredients {
                        
                        self.ingredients.append("\(ingredient.amount.us.value) \(ingredient.amount.us.unit) - \(ingredient.name)")
                    }
                    
                    for ingredient in self.ingredients {
                        self.ingredientsLabel.text?.append("\(ingredient)\n")
                    }
                    
                case .failure(let error):
                    print("Error fetching ingredients: \(error)")
                }
            }
        }
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
