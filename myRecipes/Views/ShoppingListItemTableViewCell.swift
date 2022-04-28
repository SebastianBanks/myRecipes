//
//  ShoppingListItemTableViewCell.swift
//  myRecipes
//
//  Created by Sebastian Banks on 4/26/22.
//

import UIKit

class ShoppingListItemTableViewCell: UITableViewCell {

    @IBOutlet weak var isMarkedButton: UIButton!
    @IBOutlet weak var itemLabel: UILabel!
    
    var item: ShoppingListItem? {
        didSet {
            updateViewCell()
        }
    }
    
    @IBAction func isMarkedButtonTapped(_ sender: Any) {
        print("button pressed")
        guard let item = item else { return }
        
        ShoppingListController.shared.toggleIsMarked(item) { success in
            DispatchQueue.main.async {
                if success {
                    self.updateViewCell()
                }
            }
            
        }
    }
    
    func updateViewCell() {
        guard let item = item else { return }
        
        let isMarkedImage = UIImage(systemName: "checkmark.circle.fill")
        isMarkedImage?.withTintColor(.red)
        let isNotMarkedImage = UIImage(systemName: "circle")
        isNotMarkedImage?.withTintColor(.red)
        
        isMarkedButton.setImage(item.isMarked ? isMarkedImage : isNotMarkedImage, for: .normal)
        itemLabel.text = "\(item.amount) - \(item.name)"
    }
    

}
