//
//  ScrollViewController.swift
//  myRecipes
//
//  Created by Sebastian Banks on 4/27/22.
//

import UIKit

class ScrollViewController: UIViewController {
    
    @IBOutlet weak var recipeNameTitleBar: UINavigationItem!
    
    
    var recipe: Recipe?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        let scrollView = UIScrollView(frame: view.bounds)
        setupView()
    }
    
    func setupView() {
        
        if let recipe = recipe {
            let scrollView = UIScrollView(frame: CGRect(x: 10, y: 10, width: view.frame.size.width, height: view.frame.size.height - 20))
//            scrollView.backgroundColor = .green
            view.addSubview(scrollView)
            
            self.recipeNameTitleBar.title = recipe.name
            
            let recipeImage = UIImageView(frame: CGRect(x: 10, y: 10, width: Int(view.frame.size.width) - 40, height: 200))
            recipeImage.image = recipe.recipeImage
            
            
            let width = view.frame.size.width - 40
            var ingredientText = ""
            var dirctionsText = ""
            
            for ingredient in recipe.ingredients {
                ingredientText += "\(ingredient)\n"
            }
            
            for direction in recipe.directions {
                dirctionsText += "\(direction)\n\n"
            }
            
            let ingredientTitleY = recipeImage.frame.height + 60
            
            let ingredientTitleLabel = UILabel(frame: CGRect(x: 10, y: ingredientTitleY, width: width, height: 24))
            ingredientTitleLabel.text = "Ingredients"
            ingredientTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)
            
            
            let ingredientHeight = heightForLabel(text: ingredientText, width: width)
            let directionHeight = heightForLabel(text: dirctionsText, width: width)
            
            let ingredientY = ingredientTitleY + ingredientTitleLabel.frame.height + 20
            
            let ingredientTextLabel = UILabel(frame: CGRect(x: 10, y: ingredientY, width: width, height: ingredientHeight))
            ingredientTextLabel.text = ingredientText
            ingredientTextLabel.numberOfLines = 0
            ingredientTextLabel.lineBreakMode = .byWordWrapping
            
            let directionsTitleY = ingredientY + ingredientTextLabel.frame.height
            
            let directionsTitleLabel = UILabel(frame: CGRect(x: 10, y: directionsTitleY, width: width, height: 24))
            directionsTitleLabel.text = "Directions"
            directionsTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)
            
            let directionsY = directionsTitleY + directionsTitleLabel.frame.height + 20
            
            let directionsTextLabel = UILabel(frame: CGRect(x: 10, y: directionsY, width: width, height: directionHeight))
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toEditRecipeVC",
            let destination = segue.destination as? NewRecipeViewController {
                guard let recipe = self.recipe else { return }
                destination.recipe = recipe
        }
    }
    

}


