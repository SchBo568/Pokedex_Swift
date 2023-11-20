//
//  ViewController.swift
//  Pokedex_Swift
//
//  Created by Schwickert Bob on 17/11/2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(list)
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "allCell")
        let pokemonEntry = list[indexPath.row]
        cell.textLabel?.text = pokemonEntry?.pokemon_species.name
        return cell
    }
    
    
    
    let api = PokeAPIService()
    var list: [PokemonEntry?] = []
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var testLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        api.fetchPokemonList(){pokemonList in
            DispatchQueue.main.async {
                self.list = pokemonList
                self.tableView.reloadData()
            }
        }
        
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

