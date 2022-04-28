//
//  Recipe.swift
//  myRecipes
//
//  Created by Sebastian Banks on 4/18/22.
//


import UIKit
import CloudKit

struct RecipeStrings {
    static let recordtypeKey = "Recipe"
    fileprivate static let nameKey = "name"
    fileprivate static let ingredientsKey = "ingredients"
    fileprivate static let directionsKey = "directions"
    fileprivate static let ingridientReferenceKey = "ingredientReference"
    fileprivate static let photoAssetKey = "photoAsset"
}

class Recipe {
    var name: String
    var ingredients: [String]
    var directions: [String]
    var recipeImage: UIImage? {
        get {
            guard let photoData = self.photoData else { return nil }
            return UIImage(data: photoData)
        } set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    var photoData: Data?
    
    var recordID: CKRecord.ID
//    var ingredientReferences: [CKRecord.Reference] // ckreference to ingrediant
//    let ingredientAmount: [String : String]
    var photoAsset: CKAsset? {
        get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpeg")
            
            do {
                try photoData?.write(to: fileURL)
            } catch {
                print(error)
            }
            
            return CKAsset(fileURL: fileURL)
        }
    }
    
    init(name: String, ingredients: [String], directions: [String], recipeImage: UIImage? = nil, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.name = name
        self.ingredients = ingredients
        self.directions = directions
        self.recordID = recordID
//        self.ingredientReferences = ingredients
        self.recipeImage = recipeImage
    }
}

extension Recipe {
    convenience init?(ckRecord: CKRecord) {
        guard let name = ckRecord[RecipeStrings.nameKey] as? String,
              let ingredients = ckRecord[RecipeStrings.ingredientsKey] as? [String],
              let directions = ckRecord[RecipeStrings.directionsKey] as? [String]
        else { return nil}
        
//        guard let ingridientsReference = ckRecord[RecipeStrings.ingridientReferenceKey] as? [CKRecord.Reference] else { return nil }
        
        var foundPhoto: UIImage?
        if let photoAsset = ckRecord[RecipeStrings.photoAssetKey] as? CKAsset {
            do {
                guard let url = photoAsset.fileURL else { return nil }
                let data = try Data(contentsOf: url)
                foundPhoto = UIImage(data: data)
            } catch {
                print("🖼❌ Could not transform asset to data")
            }
        }
        
        self.init(name: name, ingredients: ingredients, directions: directions, recipeImage: foundPhoto, recordID: ckRecord.recordID)
    }
}

extension Recipe: Equatable {
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.recordID == rhs.recordID
    }
    
    
}

extension CKRecord {
    convenience init(recipe: Recipe) {
        self.init(recordType: RecipeStrings.recordtypeKey, recordID: recipe.recordID)
        self.setValuesForKeys([
            RecipeStrings.nameKey : recipe.name,
            RecipeStrings.ingredientsKey : recipe.ingredients,
            RecipeStrings.directionsKey : recipe.directions,
            RecipeStrings.photoAssetKey : recipe.photoAsset
        ])
    }
}


