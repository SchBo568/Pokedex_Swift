//
//  PokeAPI.swift
//  Pokedex_Swift
//
//  Created by Schwickert Bob on 17/11/2023.
//

import Foundation
import UIKit
class PokeAPIService {
    
    func fetchPokemonList(completion: @escaping ([PokemonEntry?]) -> Void){
        let urlString = "https://pokeapi.co/api/v2/pokedex/2"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion([nil])
            return
        }
        
        URLSession.shared.dataTask(with: url){ data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion([nil])
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                print("Invalid response")
                completion([nil])
                return
            }
            
            if let data = data {
                do {
                    // Decode the data into the Pokemon model directly
                    let list = try JSONDecoder().decode(ListPokemon.self, from: data).pokemon_entries
                    //print(list)
                    completion(list)
                    
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion([nil])
                }
            }
        }.resume()
    }
    
    func fetchPokemonListSimple(completion: @escaping ([(name: String, url: String, color: String)]?) -> Void) {
        let urlString = "https://pokeapi.co/api/v2/pokedex/2"
        
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
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    
                    // Extract necessary information
                    if let pokemonEntries = json?["pokemon_entries"] as? [[String: Any]] {
                        var parsedEntries: [(name: String, url: String, color: String)] = []
                        
                        let dispatchGroup = DispatchGroup()
                        
                        for entry in pokemonEntries {
                            dispatchGroup.enter()
                            
                            if let pokemonName = entry["pokemon_species"] as? [String: Any],
                               let name = pokemonName["name"] as? String,
                               let pokemonURL = pokemonName["url"] as? String {
                                let splitted = pokemonURL.components(separatedBy: "/")
                                let realUrl = "https://pokeapi.co/api/v2/pokemon/" + splitted[6]
                                
                                self.fetchPokemonTypes(for: realUrl) { types in
                                    if let type = types?.first {
                                        parsedEntries.append((name: name, url: pokemonURL, color: type))
                                    } else {
                                        // Handle error or provide a default color
                                        parsedEntries.append((name: name, url: pokemonURL, color: "default"))
                                    }
                                    dispatchGroup.leave()
                                }
                            } else {
                                dispatchGroup.leave()
                            }
                        }
                        
                        dispatchGroup.notify(queue: .main) {
                            completion(parsedEntries)
                        }
                    } else {
                        print("No 'pokemon_entries' found in response")
                        completion(nil)
                    }
                    
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion(nil)
                }
            }
        }.resume()
    }
    
    func fetchPokemonTypes(for pokemonURL: String, completion: @escaping ([String]?) -> Void) {
        guard let url = URL(string: pokemonURL) else {
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
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    
                    if let types = json?["types"] as? [[String: Any]] {
                        let pokemonTypes = types.compactMap { type -> String? in
                            if let typeName = type["type"] as? [String: Any],
                               let name = typeName["name"] as? String {
                                return name
                            }
                            return nil
                        }
                        completion(pokemonTypes)
                    } else {
                        print("No 'types' found in response")
                        completion(nil)
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion(nil)
                }
            }
        }.resume()
    }

    
    
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
