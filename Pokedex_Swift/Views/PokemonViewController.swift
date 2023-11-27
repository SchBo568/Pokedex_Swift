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
    @IBOutlet var type1: UIImageView!
    @IBOutlet var type2: UIImageView!
    @IBOutlet var weight: UILabel!
    @IBOutlet var height: UILabel!
    @IBOutlet var hp: UILabel!
    @IBOutlet var attack: UILabel!
    @IBOutlet var defense: UILabel!
    @IBOutlet var specialAttack: UILabel!
    @IBOutlet var specialDefense: UILabel!
    @IBOutlet var speed: UILabel!
    
    override func viewDidLoad() {
        api.fetchPokemon(name: selectedPokemon!.name) { pokemon in
            DispatchQueue.main.async {
                print(pokemon)
                self.nameLabel.text = pokemon?.name.capitalized
                if let frontDefaultURL = pokemon?.sprites.front_default {
                    self.loadImageFromURL(url: frontDefaultURL)
                }
                
                print(pokemon?.types[0].type.name.capitalized as Any)
                self.type1.image = UIImage(named: (pokemon?.types[0].type.name.capitalized)!)
                if((pokemon?.types.count)! > 1){
                    self.type2.image = UIImage(named: (pokemon?.types[1].type.name.capitalized)!)
                }
                
                self.weight.text = "\(self.weight.text ?? "") \(pokemon?.weight ?? 0) g"
                self.height.text = "\(self.height.text ?? "") \(pokemon?.height ?? 0) cm"
                self.hp.text = "\(self.hp.text ?? "") \(pokemon!.stats[0].base_stat)"
                self.attack.text = "\(self.attack.text ?? "") \(pokemon!.stats[1].base_stat)"
                self.defense.text = "\(self.defense.text ?? "") \(pokemon!.stats[2].base_stat)"
                self.specialAttack.text = "\(self.specialAttack.text ?? "") \(pokemon!.stats[3].base_stat)"
                self.specialDefense.text = "\(self.specialDefense.text ?? "") \(pokemon!.stats[4].base_stat)"
                self.speed.text = "\(self.speed.text ?? "") \(String(describing: pokemon?.stats[5].base_stat))"

            }
        }
        
        type1.image = UIImage(named: "Bug")
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
