//
//  Recipes.swift
//  myRecipes
//
//  Created by Sebastian Banks on 4/18/22.
//

import Foundation

struct TopLevelObject: Decodable {
    let results: [SpoonacularRecipe]
}

struct SpoonacularRecipe: Decodable {
    let id: Int
    let title: String
    let image: String
    let imageType: String
}

struct SpoonacularDirections: Decodable {
    let steps: [Step]
    
    struct Step: Decodable {
        let number: Int
        let step: String
    }
}

struct SpoonacularIngredients: Decodable {
    let ingredients: [SpoonacularIngredient]
    
    struct SpoonacularIngredient: Decodable {
        let name: String
        let amount: Amount
        
        struct Amount: Decodable {
            let metric: Unit
            let us: Unit
            
            struct Unit: Decodable {
                let value: Double
                let unit: String
            }
        }
    }
}




