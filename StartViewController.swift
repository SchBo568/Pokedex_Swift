//
//  StartViewController.swift
//  Pokedex_Swift
//
//  Created by Schwickert Bob on 30/11/2023.
//

import Foundation
import UIKit
class StartViewController: UIViewController{
    override func viewDidLoad() {
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Background") // Set the image
        backgroundImage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)
        view.sendSubviewToBack(backgroundImage)
        
        super.viewDidLoad()
    }
}
