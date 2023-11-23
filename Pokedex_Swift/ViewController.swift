//
//  ViewController.swift
//  Pokedex_Swift
//
//  Created by Schwickert Bob on 17/11/2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    typealias PokemonTypeMap = [String: UIColor]
    var pokemonTypeColors: PokemonTypeMap = [
        "normal": UIColor.brown,
        "fire": UIColor.red,
        "water": UIColor.blue,
        "electric": UIColor.yellow,
        "grass": UIColor.green,
        "ice": UIColor.cyan,
        "fighting": UIColor.orange,
        "poison": UIColor.purple,
        "ground": UIColor.brown,
        "flying": UIColor.gray,
        "psychic": UIColor.magenta,
        "bug": UIColor.green,
        "rock": UIColor.darkGray,
        "ghost": UIColor.black,
        "dragon": UIColor.cyan,
        "dark": UIColor.darkText,
        "steel": UIColor.lightGray,
        "fairy": UIColor.purple,
    ]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secondList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "allCell")
        let pokemonEntry = secondList[indexPath.row]
        let lighterColor = pokemonTypeColors[pokemonEntry.color]!.withAlphaComponent(0.4)
        cell.textLabel?.text = pokemonEntry.name
        
        cell.contentView.backgroundColor = lighterColor
        cell.contentView.layer.cornerRadius = 10 // Adjust the value to change the roundness
        cell.contentView.layer.masksToBounds = true
        cell.contentView.clipsToBounds = true
        
        // Optional: Set a border or shadow
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        
        /*let padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8) // Adjust the values as needed
        cell.contentView.frame = cell.contentView.frame.inset(by: padding)*/
        
        return cell
    }
    
    
    
    let api = PokeAPIService()
    var list: [PokemonEntry?] = []
    var secondList: [(name: String, url: String, color: String)] = []

    
    
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
                    self.tableView.reloadData()
                } else {
                    print("Failed to fetch Pokemon.")
                }
            }
        }
        
        api.fetchPokemonListSimple(){pokemonList in
            DispatchQueue.main.async {
                self.secondList = pokemonList!
                self.tableView.reloadData()
            }
        }
        
    }
    
}

