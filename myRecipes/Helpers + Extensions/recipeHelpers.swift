//
//  recipeHelpers.swift
//  myRecipes
//
//  Created by Sebastian Banks on 4/28/22.
//

import Foundation
import UIKit

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
        
        return String(returnString.dropLast(2))
    }
}

extension ScrollViewController {
    func heightForLabel(text: String, width: CGFloat) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
}

extension RecipeViewController {
    func heightForLabel(text: String, width: CGFloat) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
}

extension DiscoverTableViewController: UITextFieldDelegate {
//    func initializeHideKeyboard() {
//        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        view.addGestureRecognizer(tap)
//    }
//    
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
}

extension NewRecipeViewController: UITextFieldDelegate {
    func initializeHideKeyboard() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}


