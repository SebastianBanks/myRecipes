//
//  recipeHelpers.swift
//  myRecipes
//
//  Created by Sebastian Banks on 4/28/22.
//

import Foundation

extension String {
    func convertToRecipeFormat() -> [String] {
        
        let string = self
        var returnArray: [String] = []
        
        if !string.contains(",") {
            returnArray.append(string)
        } else {
            let splitString = string.split(separator: ",")
            
            for word in splitString {
                let index = word.startIndex
                
                if word[index] == " " {
                    let formatted = String(word.dropFirst())
                    returnArray.append(formatted)
                } else {
                    returnArray.append(String(word))
                }
            }
        }
        
        return returnArray
    }
}

extension Array {
    func convertToEditFormat() -> String {
        
        var returnString: String = ""
        
        for word in self {
            returnString += "\(word), "
        }
        if returnString.last == " " {
            returnString.removeLast()
        }
        
        if returnString.last == "," {
            returnString.removeLast()
        }
        
        return returnString
    }
}
