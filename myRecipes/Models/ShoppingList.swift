//
//  ShoppingList.swift
//  myRecipes
//
//  Created by Sebastian Banks on 4/18/22.
//

import Foundation
import CloudKit

struct ShoppingListStrings {
    static let recordTypeKey = "ShoppingListItem"
    fileprivate static let nameKey = "name"
    fileprivate static let amountKey = "amount"
    fileprivate static let isMarkedKey = "isMarked"
}

class ShoppingListItem {
    
    var name: String
    var amount: String
    var isMarked: Bool
    
    var recordID: CKRecord.ID
    
    init(name: String, amount: String, isMarked: Bool, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.name = name
        self.amount = amount
        self.isMarked = isMarked
        self.recordID = recordID
    }
}

extension ShoppingListItem {
    convenience init?(ckRecord: CKRecord) {
        guard let name = ckRecord[ShoppingListStrings.nameKey] as? String,
              let amount = ckRecord[ShoppingListStrings.amountKey] as? String,
              let isMarked = ckRecord[ShoppingListStrings.isMarkedKey] as? Bool
        else { return nil }
        
        self.init(name: name, amount: amount, isMarked: isMarked, recordID: ckRecord.recordID)
    }
}

extension ShoppingListItem: Equatable {
    static func == (lhs: ShoppingListItem, rhs: ShoppingListItem) -> Bool {
        return lhs.recordID == rhs.recordID
    }
    
    
}

extension CKRecord {
    convenience init(shoppingListItem: ShoppingListItem) {
        self.init(recordType: ShoppingListStrings.recordTypeKey, recordID: shoppingListItem.recordID)
        self.setValuesForKeys([
            ShoppingListStrings.nameKey : shoppingListItem.name,
            ShoppingListStrings.amountKey : shoppingListItem.amount,
            ShoppingListStrings.isMarkedKey : shoppingListItem.isMarked
        ])
    }
}
