//
//  Ingredient.swift
//  myRecipes
//
//  Created by Sebastian Banks on 4/18/22.
//

/*

import Foundation
import CloudKit

struct IngredientStrings {
    static let recordTypeKey = "Ingredient"
    fileprivate static let nameKey = "name"
    fileprivate static let amountKey = "amount"
    static let appleIngredientReferenceKey = "appleIngredientReference"
}

class Ingredient: Hashable {
    let name: String
//    let amount: String
    
    var recordID: CKRecord.ID
    var appleIngredientReference: CKRecord.Reference
    
    init(name: String, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), appleIngredientReference: CKRecord.Reference) {
        self.name = name
//        self.amount = amount
        self.recordID = recordID
        self.appleIngredientReference = appleIngredientReference
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name.hashValue)
    }
    
}

extension Ingredient {
    convenience init?(ckRecord: CKRecord) {
        guard let name = ckRecord[IngredientStrings.nameKey] as? String,
              let amount = ckRecord[IngredientStrings.amountKey] as? String,
              let appleIngredientReference = ckRecord[IngredientStrings.appleIngredientReferenceKey] as? CKRecord.Reference
        else { return nil}
        
        self.init(name: name, recordID: ckRecord.recordID, appleIngredientReference: appleIngredientReference)
    }
}

extension Ingredient: Equatable {
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        return lhs.recordID == rhs.recordID
    }
    
    
}

extension CKRecord {
    convenience init(ingredient: Ingredient) {
        self.init(recordType: IngredientStrings.recordTypeKey, recordID: ingredient.recordID)
        self.setValuesForKeys([
            IngredientStrings.nameKey : ingredient.name,
//            IngredientStrings.amountKey : ingredient.amount,
            IngredientStrings.appleIngredientReferenceKey : ingredient.appleIngredientReference
        ])
    }
}

*/
