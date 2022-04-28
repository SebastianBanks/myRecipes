//
//  SpoonacularController.swift
//  myRecipes
//
//  Created by Sebastian Banks on 4/19/22.
//

import Foundation
import UIKit

class SpoonacularController {
    
    static let baseURL = URL(string: "https://api.spoonacular.com")
    
    static let recipesComponent = "recipes"
    static let complexSearchComponent = "complexSearch"
    static let analyzedInstructionsComponent = "analyzedInstructions"
    static let ingrediantWidgetComponent = "ingredientWidget.json"
    
    static let apiKey = "apiKey"
    static let queryKey = "query"
    static let instructionsRequiredKey = "instructionsRequired"
    static let dietKey = "diet"
    static let intolerencesKey = "intolerances"
    static let maxReadyTimeKey = "maxReadyTime"
    static let numberKey = "number"
    
    
    static var apiKeyValue: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "Keys", ofType: "plist") else {
                fatalError("Couldn't find file 'Keys.plist'.")
            }
            
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "API_KEY") as? String else {
                fatalError("Couldn't find key 'API_KEY' in 'Keys.plist'.")
            }
            return value
        }
    }
    
    static func fetchRecipeWith(searchTerm: String, diet: String?, intolerences: String?, maxReadyTime: Int?, completion: @escaping (Result<[SpoonacularRecipe], SpoonacularError>) -> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidError)) }
        
        let recipeURL = baseURL.appendingPathComponent(recipesComponent)
        let complexSearchURL = recipeURL.appendingPathComponent(complexSearchComponent)
        
        var components = URLComponents(url: complexSearchURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: apiKey, value: apiKeyValue)
        let searchQuery = URLQueryItem(name: queryKey, value: searchTerm)
        let numberQuery = URLQueryItem(name: numberKey, value: "25")
        components?.queryItems = [searchQuery, numberQuery, apiQuery]
        
        if let diet = diet {
            if diet != "none" {
                let dietQuery = URLQueryItem(name: dietKey, value: diet)
                components?.queryItems?.append(dietQuery)
            }
        }
        
        if let intolerences = intolerences {
            if intolerences != "none" {
                let intolerencesQuery = URLQueryItem(name: intolerencesKey, value: intolerences)
                components?.queryItems?.append(intolerencesQuery)
            }
        }
        
        if let maxReadyTime = maxReadyTime {
            if maxReadyTime != 69 {
                let maxReadyTimeQuery = URLQueryItem(name: maxReadyTimeKey, value: String(maxReadyTime))
                components?.queryItems?.append(maxReadyTimeQuery)
            }
        }
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidError)) }
        
        print("\nFinalURL for Fetch Recipe ::: \(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                completion(.failure(.thrownError(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Fetch Recipe Status Code : \(response.statusCode)")
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let topLevelObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
                let recipes = topLevelObject.results
                return completion(.success(recipes))
            } catch {
                return completion(.failure(.thrownError(error)))
            }

        }.resume()
    }
    
    static func fetchRecipeDirections(id: Int, completion: @escaping (Result<SpoonacularDirections, SpoonacularError>) -> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidError)) }
        
        let recipeURL = baseURL.appendingPathComponent(recipesComponent)
        let idURL = recipeURL.appendingPathComponent(String(id))
        let analyzedInstructionsURL = idURL.appendingPathComponent(analyzedInstructionsComponent)
        
        var components = URLComponents(url: analyzedInstructionsURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: apiKey, value: apiKeyValue)
        components?.queryItems = [apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidError)) }
        print("\nFinalURL for Fetch Directions ::: \(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                completion(.failure(.thrownError(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("fetch directions status code : \(response.statusCode)")
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let spoonacularDirections = try JSONDecoder().decode([SpoonacularDirections].self, from: data)
                return completion(.success(spoonacularDirections[0]))
            } catch {
                return completion(.failure(.unableToDecode))
            }

        }.resume()
    }
    
    static func fetchRecipeIngredients(id: Int, completion: @escaping (Result<SpoonacularIngredients, SpoonacularError>) -> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidError)) }
        
        let recipeURL = baseURL.appendingPathComponent(recipesComponent)
        let idURL = recipeURL.appendingPathComponent(String(id))
        let ingredientsWidgetURL = idURL.appendingPathComponent(ingrediantWidgetComponent)
        
        var components = URLComponents(url: ingredientsWidgetURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: apiKey, value: apiKeyValue)
        components?.queryItems = [apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidError)) }
        print("\nFinalURL for Fetch ingrediants ::: \(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                completion(.failure(.thrownError(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("fetch ingredients status code : \(response.statusCode)")
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let ingrediants = try JSONDecoder().decode(SpoonacularIngredients.self, from: data)
                return completion(.success(ingrediants))
            } catch {
                return completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    static func fetchImage(with recipeURL: String, completion: @escaping (Result<UIImage, SpoonacularError>) -> Void) {
        
        guard let imageURL = URL(string: recipeURL) else { return completion(.failure(.noData))}
        
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                completion(.failure(.thrownError(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Fetch image status code: \(response.statusCode)")
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            guard let recipeImage = UIImage(data: data) else { return completion(.failure(.unableToDecode)) }
            completion(.success(recipeImage))

        }.resume()
    }
}
