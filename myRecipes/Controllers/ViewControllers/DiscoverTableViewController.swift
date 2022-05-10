//
//  DiscoverTableViewController.swift
//  myRecipes
//
//  Created by Sebastian Banks on 4/22/22.
//

import UIKit
import CoreML
import Vision

class DiscoverTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    var recipes: [SpoonacularRecipe] = []
    
    @IBOutlet weak var searchRecipe: UITextField!
    @IBOutlet weak var dietButton: UIButton!
    @IBOutlet weak var intoleranceButton: UIButton!
    @IBOutlet weak var readyTimeButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        initializeHideKeyboard()
        setupMenuButtons()
//        imagePicker.delegate = self
//        imagePicker.sourceType = .camera
//        imagePicker.allowsEditing = false
        searchRecipe.delegate = self
        searchRecipe.tag = 1
    }
    
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        guard let searchRecipe = searchRecipe.text, !searchRecipe.isEmpty else { return }
        
        let diet = dietButton.menu?.selectedElements[0].title
        let intolerance = intoleranceButton.menu?.selectedElements[0].title
        let readyTime = Int(readyTimeButton.menu?.selectedElements[0].title.prefix(2) ?? "69")
        
        SpoonacularController.fetchRecipeWith(searchTerm: searchRecipe, diet: diet, intolerences: intolerance, maxReadyTime: readyTime) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let recipes):
                    self.recipes = recipes
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error fetching recipes: \(error.localizedDescription)")
                }
            }
        }
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func setupMenuButtons() {
        
        let noneItem = UIAction(title: "none") { action in print("none tapped")}
        
        let ketogenicItem = UIAction(title: "ketogenic") { action in print("ketogenic tapped")}
        let vegetarianItem = UIAction(title: "vegetarian") { action in print("vegatarian tapped")}
        let veganItem = UIAction(title: "vegan") { action in print("vegan tapped")}
        let pescatarianItem = UIAction(title: "pescetarian") { action in print("pescetarian tapped")}
        let paleoItem = UIAction(title: "paleo") { action in print("paleo tapped")}
        let primalItem = UIAction(title: "primal") { action in print("primal tapped")}
        
        let dietMenu = UIMenu(title: "Diet", options: .displayInline, children: [noneItem, ketogenicItem, vegetarianItem, veganItem, pescatarianItem, paleoItem, primalItem])
        
        dietButton.menu = dietMenu
        dietButton.showsMenuAsPrimaryAction = true
        
        let dairyItem = UIAction(title: "dairy") { action in print("dairy tapped")}
        let eggItem = UIAction(title: "egg") { action in print("egg tapped")}
        let glutenItem = UIAction(title: "gluten") { action in print("gluten tapped")}
        let grainItem = UIAction(title: "grain") { action in print("grain tapped")}
        let peanutItem = UIAction(title: "peanut") { action in print("peanut tapped")}
        let seafoodItem = UIAction(title: "seafood") { action in print("seafood tapped")}
        let shellfishItem = UIAction(title: "shellfish") { action in print("shellfish tapped")}
        let sesameItem = UIAction(title: "sesame") { action in print("sesame tapped")}
        let soyItem = UIAction(title: "soy") { action in print("soy tapped")}
        let wheatItem = UIAction(title: "wheat") { action in print("wheat tapped")}
        
        let intolerancesMenu = UIMenu(title: "Intolerances", options: .displayInline, children: [noneItem, dairyItem, eggItem, glutenItem, grainItem, peanutItem, seafoodItem, shellfishItem, sesameItem, soyItem, wheatItem])
        intoleranceButton.menu = intolerancesMenu
        intoleranceButton.showsMenuAsPrimaryAction = true
        
        let tenMinItem = UIAction(title: "10 mins") { action in print("10mins tapped")}
        let twentyMinItem = UIAction(title: "20 mins") { action in print("20mins tapped")}
        let thirtyMinItem = UIAction(title: "30 mins") { action in print("30mins tapped")}
        let fortyMinItem = UIAction(title: "40 mins") { action in print("40mins tapped")}
        let fiftyMinItem = UIAction(title: "50 mins") { action in print("50mins tapped")}
        let sixtyMinItem = UIAction(title: "60 mins") { action in print("60mins tapped")}
        let seventyMinItem = UIAction(title: "70 mins") { action in print("70mins tapped")}
        let eightyMinItem = UIAction(title: "80 mins") { action in print("80mins tapped")}
        let ninetyMinItem = UIAction(title: "90 mins") { action in print("90mins tapped")}
        let hundredMinItem = UIAction(title: "100 mins") { action in print("100mins tapped")}
        let hundredTenMinItem = UIAction(title: "110 mins") { action in print("110mins tapped")}
        let hundredTwentyMinItem = UIAction(title: "120 mins") { action in print("120mins tapped")}
        
        let readyTimeMenu = UIMenu(title: "Ready Time", options: .displayInline, children: [noneItem, tenMinItem, twentyMinItem, thirtyMinItem, fortyMinItem, fiftyMinItem, sixtyMinItem, seventyMinItem, eightyMinItem, ninetyMinItem, hundredMinItem, hundredTenMinItem, hundredTwentyMinItem])
        readyTimeButton.menu = readyTimeMenu
        readyTimeButton.showsMenuAsPrimaryAction = true
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert to ciImage")
            }
            
            detect(image: ciImage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    func detect(image: CIImage) {
        
        //Just change MyImageClassifier() to switch between models
        guard let model = try? VNCoreMLModel(for: foodIdentifier().model) else {
            fatalError("Loading CoreML model failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }
            
            if let firstResult = results.first {
                let mlResult = firstResult.identifier
                self.searchRecipe.text = mlResult
                SpoonacularController.fetchRecipeWith(searchTerm: mlResult, diet: nil, intolerences: nil, maxReadyTime: nil) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let recipes):
                            self.recipes = recipes
                            self.tableView.reloadData()
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }
            print(results)
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recipes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipeTableViewCell else { return UITableViewCell() }

        // Configure the cell...
        let recipe = recipes[indexPath.row]
        cell.recipe = recipe
        
        return cell
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecipe",
            let indexPath = tableView.indexPathForSelectedRow,
            let destination = segue.destination as? RecipeViewController {
                let recipe = recipes[indexPath.row]
                destination.recipe = recipe
            SpoonacularController.fetchImage(with: recipe.image) { result in
                switch result {
                case .success(let image):
                    destination.recipeImageFetched = image
                case .failure(let error):
                    print("error passing image: \(error)")
                }
            }
                print(indexPath.row)
        } else {
            print("error")
        }
    }

}
