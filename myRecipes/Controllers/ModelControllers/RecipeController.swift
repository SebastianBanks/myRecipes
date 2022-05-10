//
//  RecipeController.swift
//  myRecipes
//
//  Created by Sebastian Banks on 4/19/22.
//

import Foundation
import CloudKit
import UIKit

class RecipeController {
    
    static let shared = RecipeController()
    
    var recipes: [Recipe] = []
    
    let privateDB = CKContainer.default().privateCloudDatabase
    
    func saveRecipe(with name: String, ingredients: [String], directions: [String], image: UIImage?, completion: @escaping (Bool) -> Void) {
        

        let newRecipe = Recipe(name: name, ingredients: ingredients, directions: directions, recipeImage: image)
        
        let recipeRecord = CKRecord(recipe: newRecipe)
        
        privateDB.save(recipeRecord) { record, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                completion(false)
                return
            }
            
            guard let record = record,
                  let savedRecipe = Recipe(ckRecord: record)
            else { completion(false) ; return }
            
            print("Saved Recipe successfully")
            self.recipes.insert(savedRecipe, at: 0)
            completion(true)

        }
    }
    
    func fetchRecipes(completion: @escaping (Bool) -> Void) {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: RecipeStrings.recordtypeKey, predicate: predicate)
        
        privateDB.perform(query, inZoneWith: nil) { records, error in
            
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                completion(false)
                return
            }
            
            guard let records = records else { completion(false) ; return }
            print("Fetched all Recipes")
            
            let fetchedRecipes = records.compactMap { Recipe(ckRecord: $0) }
            self.recipes = fetchedRecipes
            completion(true)

        }
    }

    func updateRecipe(_ recipe: Recipe, completion: @escaping (Bool) -> Void) {
        
        let recordToUpdate = CKRecord(recipe: recipe)
        let operation = CKModifyRecordsOperation(recordsToSave: [recordToUpdate])
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { (records, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                completion(false)
                return
            }
            
            guard let record = records?.first else { completion(false) ; return }
            print("Update \(record.recordID.recordName) successfully in CloudKit")
            completion(true)
        }
        privateDB.add(operation)
    }
    
    func deleteRecipe(_ recipe: Recipe, completion: @escaping (Bool) -> Void) {
        
        let operation = CKModifyRecordsOperation(recordIDsToDelete: [recipe.recordID])
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { (_, recordIDs, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                completion(false)
                return
            }
            
            guard let recordIDs = recordIDs else { completion(false) ; return }
            print("\(recordIDs) were removed successfully")
            completion(true)
        }
        privateDB.add(operation)
    }
}
