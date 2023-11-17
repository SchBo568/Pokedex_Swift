import Foundation

// MARK: - AbilityElement
struct AbilityElement: Codable {
    let ability: MoveClass
    let is_hidden: Bool
    let slot: Int
}

// MARK: - MoveClass
struct MoveClass: Codable {
    let name: String
    let url: String
}

// MARK: - Move
struct Move: Codable {
    let move: MoveClass
    let version_group_details: [VersionGroupDetail]
}

// MARK: - VersionGroupDetail
struct VersionGroupDetail: Codable {
    let level_learned_at: Int
    let move_learn_method, version_group: MoveClass
}

// MARK: - Sprites
struct Sprites: Codable {
    let back_default: String
    let back_female: String?
    let back_shiny: String
    let back_shiny_female: String?
    let front_default: String
}


// MARK: - Stat
struct Stat: Codable {
    let base_stat, effort: Int
    let stat: MoveClass
}

// MARK: - TypeElement
struct TypeElement: Codable {
    let slot: Int
    let type: MoveClass
}

struct Pokemon: Codable{
    let abilities: [AbilityElement]
    let height, id: Int
    let moves: [Move]
    let name: String
    let sprites: Sprites
    let stats: [Stat]
    let types: [TypeElement]
    let weight: Int
}
