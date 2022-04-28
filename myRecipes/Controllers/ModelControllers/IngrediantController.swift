//
//  IngrediantController.swift
//  myRecipes
//
//  Created by Sebastian Banks on 4/19/22.
//

/*

import Foundation
import CloudKit

class IngredientController {
    
    static let shared = IngredientController()
    
    var recipeIngredients: [Ingredient] = []
    
    let privateDB = CKContainer.default().privateCloudDatabase
    
    func createIngredient(with recipe: Recipe, name: String, amount: String, completion: @escaping (Bool) -> Void) {

        let reference = CKRecord.Reference(recordID: recipe.recordID, action: .deleteSelf)

        let newIngredient = Ingredient(name: name, appleIngredientReference: reference)

        let record = CKRecord(ingredient: newIngredient)

        self.privateDB.save(record) { record, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                completion(false)
                return
            }

            guard let record = record,
                  let savedIngredient = Ingredient(ckRecord: record)
            else { completion(false) ; return }

            self.recipeIngredients.append(savedIngredient)
            print("Created Ingredient: \(record.recordID.recordName) successfully")
            completion(true)
        }
        
    }
    
    func fetchIngredientsFor(recipe: Recipe, completion: @escaping (Bool) -> Void) {
        
        let recipeID = recipe.recordID
        
        let predicate = NSPredicate(format: "\(IngredientStrings.appleIngredientReferenceKey) == %@", recipeID)
        let query = CKQuery(recordType: IngredientStrings.recordTypeKey, predicate: predicate)
        
        privateDB.perform(query, inZoneWith: nil) { records, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                completion(false)
                return
            }
            
            guard let records = records else { completion(false) ; return }
            
            let fetchedRecipes = records.compactMap { Ingredient(ckRecord: $0) }
            self.recipeIngredients = fetchedRecipes
            
            completion(true)

        }
        
    }
    
    
}

*/
