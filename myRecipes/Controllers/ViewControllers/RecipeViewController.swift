//
//  RecipeViewController.swift
//  myRecipes
//
//  Created by Sebastian Banks on 4/22/22.
//

import UIKit

class RecipeViewController: UIViewController {
    
    @IBOutlet weak var recipeTitle: UINavigationItem!
    
    let scrollView = UIScrollView()
    let recipeImage = UIImageView()
    let ingredientTitleLabel = UILabel()
    let ingredientTextLabel = UILabel()
    let directionsTitleLabel = UILabel()
    let directionsTextLabel = UILabel()
    
    var recipe: SpoonacularRecipe?
    var recipeImageFetched: UIImage?
    var ingredients: [String] = []
    var directions: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getRecipeData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        let scrollView = UIScrollView(frame: view.bounds)
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
    
    
    func setupView() {
        print(ingredients)
        print(directions)
        
        if let recipe = recipe {
            
            scrollView.frame = CGRect(x: 10, y: 10, width: view.frame.size.width, height: view.frame.size.height - 20)
//            scrollView.backgroundColor = .green
            view.addSubview(scrollView)
            
            self.recipeTitle.title = recipe.title
            
            
            recipeImage.frame = CGRect(x: 10, y: 10, width: Int(view.frame.size.width) - 40, height: 200)
            recipeImage.image = recipeImageFetched
            
            
            let width = view.frame.size.width - 40
            
            var ingredientText = ""
            var dirctionsText = ""
            
            for ingredient in ingredients {
                ingredientText += "\(ingredient)\n"
            }
            
            for direction in directions {
                dirctionsText += "\(direction)\n\n"
            }
            
            let ingredientTitleY = recipeImage.frame.height + 60
            
            
            ingredientTitleLabel.frame = CGRect(x: 10, y: ingredientTitleY, width: width, height: 24)
            ingredientTitleLabel.text = "Ingredients"
            ingredientTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)
            
            
            let ingredientHeight = heightForLabel(text: ingredientText, width: width)
            let directionHeight = heightForLabel(text: dirctionsText, width: width)
            
            let ingredientY = ingredientTitleY + ingredientTitleLabel.frame.height + 20
            
            
            ingredientTextLabel.frame = CGRect(x: 10, y: ingredientY, width: width, height: ingredientHeight)
            ingredientTextLabel.text = ingredientText
            ingredientTextLabel.numberOfLines = 0
            ingredientTextLabel.lineBreakMode = .byWordWrapping
            
            let directionsTitleY = ingredientY + ingredientTextLabel.frame.height
            
            
            directionsTitleLabel.frame = CGRect(x: 10, y: directionsTitleY, width: width, height: 24)
            directionsTitleLabel.text = "Directions"
            directionsTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)
            
            let directionsY = directionsTitleY + directionsTitleLabel.frame.height + 20
            
            
            directionsTextLabel.frame = CGRect(x: 10, y: directionsY, width: width, height: directionHeight)
            directionsTextLabel.text = dirctionsText
            directionsTextLabel.numberOfLines = 0
            directionsTextLabel.lineBreakMode = .byWordWrapping
            
            scrollView.addSubview(recipeImage)
            scrollView.addSubview(ingredientTitleLabel)
            scrollView.addSubview(ingredientTextLabel)
            scrollView.addSubview(directionsTitleLabel)
            scrollView.addSubview(directionsTextLabel)
            
            let scrollViewContentHeight = directionsY + directionsTextLabel.frame.height + 20
            
            scrollView.contentSize = CGSize(width: view.frame.size.width, height: scrollViewContentHeight)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    func updateView() {
        let width = view.frame.size.width - 40
        
        scrollView.frame = CGRect(x: 10, y: 10, width: view.frame.size.width, height: view.frame.size.height - 20)
        
        var ingredientText = ""
        var dirctionsText = ""
        
        for ingredient in ingredients {
            ingredientText += "\(ingredient)\n"
        }
        
        for direction in directions {
            dirctionsText += "\(direction)\n\n"
        }
        
        ingredientTextLabel.text = ingredientText
        directionsTextLabel.text = dirctionsText
        
        let ingredientHeight = heightForLabel(text: ingredientText, width: width)
        let directionHeight = heightForLabel(text: dirctionsText, width: width)
        
        let ingredientTitleY = recipeImage.frame.height + 60
        let ingredientY = ingredientTitleY + ingredientTitleLabel.frame.height + 20
        
        ingredientTextLabel.frame = CGRect(x: 10, y: ingredientY, width: width, height: ingredientHeight)
        
        let directionsTitleY = ingredientY + ingredientTextLabel.frame.height
        directionsTitleLabel.frame = CGRect(x: 10, y: directionsTitleY, width: width, height: 24)
        
        let directionsY = directionsTitleY + directionsTitleLabel.frame.height + 20
        directionsTextLabel.frame = CGRect(x: 10, y: directionsY, width: width, height: directionHeight)
        
    }
    
    func getRecipeData() {
        print("trying to setup")
        guard let recipe = recipe else { return }
        print("setting up view")
        
        recipeTitle.title = recipe.title
        DispatchQueue.main.async(qos: .userInteractive) {
            self.fetchDirections(recipe: recipe)
            self.fetchIngredients(recipe: recipe)
            self.fetchRecipeImage(recipe: recipe)
        }
        
    }
    
    func fetchIngredients(recipe: SpoonacularRecipe) {
        
        SpoonacularController.fetchRecipeIngredients(id: recipe.id) { result in
            
                switch result {
                case .success(let ingredients):
                    for ingredient in ingredients.ingredients {

                        self.updateIngredients(str: "\(ingredient.amount.us.value) \(ingredient.amount.us.unit) - \(ingredient.name)")
                    }
                    self.updateView()
                    print(self.ingredients)

                case .failure(let error):
                    print("Error fetching ingredients: \(error)")
                }
            
        }
    }
    
    func fetchDirections(recipe: SpoonacularRecipe) {
        SpoonacularController.fetchRecipeDirections(id: recipe.id) { result in
            
                switch result {

                case .success(let directions):
                    for step in directions.steps {
                        self.updateDirections(str: "\(step.number). \(step.step)")
                    }
                    self.updateView()
                    print(self.directions)

                case .failure(let error):
                    print("Error fetching directions: \(error.localizedDescription)")
                }
            
        }
    }
    
    func fetchRecipeImage(recipe: SpoonacularRecipe) {
        
        SpoonacularController.fetchImage(with: recipe.image) { result in
            
                switch result {
                case .success(let image):
                    self.recipeImageFetched = image
                case .failure(let error):
                    self.recipeImageFetched = UIImage(systemName: "photo.artframe")
                    print("error loding image: \(error)")
                }
            
        }
    }
    

}

extension RecipeViewController {
    func updateIngredients(str: String) {
        ingredients.append(str)
        print(ingredients)
    }
    
    func updateDirections(str: String) {
        directions.append(str)
        print(directions)
    }
}
