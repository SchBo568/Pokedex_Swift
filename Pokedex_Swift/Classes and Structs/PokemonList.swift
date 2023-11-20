// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let pokemon = try? JSONDecoder().decode(Pokemon.self, from: jsonData)

import Foundation

// MARK: - Pokemon
struct ListPokemon: Decodable {
    let descriptions: [Description]
    let id: Int
    let is_main_series: Bool
    let name: String
    let names: [Name]
    let pokemon_entries: [PokemonEntry]
    let region: Region
    let version_groups: [Region]
}

// MARK: - Description
struct Description: Decodable {
    let description: String
    let language: Region
}

// MARK: - Region
struct Region: Decodable {
    let name: String
    let url: String
}

// MARK: - Name
struct Name: Decodable {
    let language: Region
    let name: String
}

// MARK: - PokemonEntry
struct PokemonEntry: Decodable {
    let entry_number: Int
    let pokemon_species: Region
}
