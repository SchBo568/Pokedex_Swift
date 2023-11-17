//
//  PokeAPI.swift
//  Pokedex_Swift
//
//  Created by Schwickert Bob on 17/11/2023.
//

import Foundation
class PokeAPIService {
    
    
    //This code definition is needed because of the asychronous task that is calling an api
    //Completion here defines the return value
    func fetchPokemon(name: String, completion: @escaping (Pokemon?) -> Void) {
        let urlString = "https://pokeapi.co/api/v2/pokemon/" + name
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                print("Invalid response")
                completion(nil)
                return
            }
            
            if let data = data {
                do {
                    // Decode the data into the Pokemon model directly
                    let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
                    completion(pokemon)
                    
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion(nil)
                }
            }
        }.resume()
    }

}
