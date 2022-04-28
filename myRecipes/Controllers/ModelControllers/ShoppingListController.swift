//
//  ShoppingListController.swift
//  myRecipes
//
//  Created by Sebastian Banks on 4/19/22.
//

import Foundation
import CloudKit

class ShoppingListController {
    
    static let shared = ShoppingListController()
    
    var items: [ShoppingListItem] = []
    
    let privateDB = CKContainer.default().privateCloudDatabase
    
    func saveItem(with name: String, amount: String, completion: @escaping (Bool) -> Void) {
        
        let newItem = ShoppingListItem(name: name, amount: amount, isMarked: false)
        
        let itemRecord = CKRecord(shoppingListItem: newItem)
        
        privateDB.save(itemRecord) { record, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                completion(false)
                return
            }
            
            guard let record = record,
                  let savedItem = ShoppingListItem(ckRecord: record)
            else { completion(false) ; return }
            
            print("Saved Item successfully")
            self.items.insert(savedItem, at: 0)
            completion(true)
        }
    }
    
    func fetchItems(completion: @escaping (Bool) -> Void) {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: ShoppingListStrings.recordTypeKey, predicate: predicate)
        privateDB.perform(query, inZoneWith: nil) { records, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                completion(false)
                return
            }
            
            guard let records = records else { completion(false) ; return }
            print("Fetched all items")
            let fetchedItems = records.compactMap { ShoppingListItem(ckRecord: $0) }
            self.items = fetchedItems
            self.items.sort {
                $0.name < $1.name
            }
            completion(true)

        }
    }
    
    func update(_ item: ShoppingListItem, completion: @escaping (Bool) -> Void) {
        
        let recordToUpdate = CKRecord(shoppingListItem: item)
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
            print("update \(record.recordID.recordName) successfully in CloudKit")
            completion(true)
        }
        privateDB.add(operation)
    }
    
    func toggleIsMarked(_ item: ShoppingListItem, completion: @escaping (Bool) -> Void) {
        item.isMarked.toggle()
        let recordToUpdate = CKRecord(shoppingListItem: item)
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
            print("update \(record.recordID.recordName) successfully in CloudKit")
            completion(true)
        }
        privateDB.add(operation)
    }
    
    func delete(_ item: ShoppingListItem, completion: @escaping (Bool) -> Void) {
        
        let operation = CKModifyRecordsOperation(recordIDsToDelete: [item.recordID])
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
