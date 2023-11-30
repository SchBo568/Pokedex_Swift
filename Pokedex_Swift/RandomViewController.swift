//
//  RandomViewController.swift
//  Pokedex_Swift
//
//  Created by Schwickert Bob on 30/11/2023.
//

import Foundation
import SwiftUI
import UIKit
class RandomViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var randomImage: UIImageView!
    @IBOutlet var catchButton: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var caughtList: UITableView!
    
    var caughtPokemon = ["charmander"]
    let api = PokeAPIService()
    let randomNumber = String(Int.random(in: 1...151))
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return caughtPokemon.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "YourCellIdentifier", for: indexPath)
            cell.textLabel?.text = caughtPokemon[indexPath.row]
            return cell
        }


        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("Selected: \(caughtPokemon[indexPath.row])")
        }
    
    override func viewDidLoad() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Background") // Set the image
        backgroundImage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)
        view.sendSubviewToBack(backgroundImage)
        
        
        super.viewDidLoad()
        caughtList.dataSource = self
        caughtList.delegate = self
        caughtList.register(UITableViewCell.self, forCellReuseIdentifier: "YourCellIdentifier")

        if let storedPokemon = UserDefaults.standard.object(forKey: "caughtPokemonList") as? [String] {
            caughtPokemon = storedPokemon
        } else {
            caughtPokemon = []
        }

        print(caughtPokemon)
        
        api.fetchPokemon(name: self.randomNumber) { pokemon in
            DispatchQueue.main.async {
                self.nameLabel.text = pokemon?.name.capitalized
                if let frontDefaultURL = pokemon?.sprites.front_default {
                    self.loadImageFromURL(url: frontDefaultURL)
                }
            }
        }
        
        catchButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
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
                    self.randomImage.image = image
                }
            }
        }.resume()
    }
    
    @objc func buttonTapped() {
            if let pokemonName = nameLabel.text {
                catchPokemon(name: pokemonName)
            }
        }
    
    func catchPokemon(name: String){
        caughtPokemon.append(name)
        catchButton.isEnabled = false
        catchButton.setTitle("Caught!", for: .normal)
        caughtList.reloadData()
        UserDefaults.standard.set(caughtPokemon, forKey: "caughtPokemonList")
    }
}
