//
//  ViewController.swift
//  Pokedex_Swift
//
//  Created by Schwickert Bob on 17/11/2023.
//

import UIKit

class ViewController: UIViewController {
    
    
    let api = PokeAPIService()
    
    @IBOutlet var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        api.fetchPokemon(name: "pikachu") { pokemon in
            DispatchQueue.main.async {
                if let pokemon = pokemon {
                    self.testLabel.text = pokemon.name
                } else {
                    print("Failed to fetch Pokemon.")
                }
            }
        }
        
    }
    
}

