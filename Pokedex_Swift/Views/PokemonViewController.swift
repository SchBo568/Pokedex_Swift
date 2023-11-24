//
//  PokemonViewController.swift
//  Pokedex_Swift
//
//  Created by Schwickert Bob on 24/11/2023.
//

import Foundation
import UIKit
class PokemonViewController: ViewController{
    var selectedPokemon: (name: String, url: String, color: String, id: Int)?
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var image: UIImageView!
    
    override func viewDidLoad() {
        print(selectedPokemon!)
        
        api.fetchPokemon(name: selectedPokemon!.name) { pokemon in
            DispatchQueue.main.async {
                self.nameLabel.text = pokemon?.name
                if let frontDefaultURL = pokemon?.sprites.front_default {
                    self.loadImageFromURL(url: frontDefaultURL)
                }
            }
        }
    }
    
    
    func loadImageFromURL(url: String) {
        guard let imageURL = URL(string: url) else { return }
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            if let imageData = data, let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self.image.image = image
                }
            }
        }.resume()
    }
}
