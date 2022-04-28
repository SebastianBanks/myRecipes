//
//  ScrollViewController.swift
//  myRecipes
//
//  Created by Sebastian Banks on 4/27/22.
//

import UIKit

class ScrollViewController: UIViewController {
    
    var recipe: Recipe?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        let scrollView = UIScrollView(frame: view.bounds)
        let scrollView = UIScrollView(frame: CGRect(x: 10, y: 10, width: view.frame.size.width - 20, height: view.frame.size.height - 20))
        scrollView.backgroundColor = .green
        
        view.addSubview(scrollView)
        
        let topButton = UIButton(frame: CGRect(x: 20, y: 20, width: 100, height: 100))
        topButton.backgroundColor = .blue
        scrollView.addSubview(topButton)
        
        let bottomButton = UIButton(frame: CGRect(x: 20, y: 2000, width: 100, height: 100))
        topButton.backgroundColor = .blue
        scrollView.addSubview(bottomButton)
        
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: 2200)
    }

    

}
