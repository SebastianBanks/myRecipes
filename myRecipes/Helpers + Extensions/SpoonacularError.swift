//
//  SpoonacularError.swift
//  myRecipes
//
//  Created by Sebastian Banks on 4/19/22.
//

import Foundation

enum SpoonacularError: LocalizedError {
    
    case invalidError
    case thrownError(Error)
    case noData
    case unableToDecode
    
    var errorDescription: String? {
        switch self {
        case .invalidError:
            return "Server failed to reach the necessary url"
        case .thrownError(let error):
            return "Error: \(error.localizedDescription), \(error)"
        case .noData:
            return "The server responded with no data"
        case .unableToDecode:
            return "Failed to decode the data"
        }
    }
}
