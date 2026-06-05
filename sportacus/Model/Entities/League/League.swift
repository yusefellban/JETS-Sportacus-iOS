import Foundation

struct League: Codable {
    let leagueKey: Int64
    let leagueName: String
    let leagueLogo: String?
    let countryName: String
    
    enum CodingKeys: String, CodingKey {
        case leagueKey = "league_key"
        case leagueName = "league_name"
        case leagueLogo = "league_logo"
        case countryName = "country_name"
    }
    
    init(leagueKey: Int64, leagueName: String, leagueLogo: String?, countryName: String) {
        self.leagueKey = leagueKey
        self.leagueName = leagueName
        self.leagueLogo = leagueLogo
        self.countryName = countryName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode leagueName
        leagueName = try container.decode(String.self, forKey: .leagueName)
        
        // Decode leagueLogo (nullable/optional)
        leagueLogo = try container.decodeIfPresent(String.self, forKey: .leagueLogo)
        
        // Decode countryName (safely fallback to "International" if null or missing)
        countryName = (try container.decodeIfPresent(String.self, forKey: .countryName)) ?? "International"
        
        // Decode leagueKey safely from either String or Int64/Int
        if let keyInt = try? container.decode(Int64.self, forKey: .leagueKey) {
            leagueKey = keyInt
        } else if let keyInt = try? container.decode(Int.self, forKey: .leagueKey) {
            leagueKey = Int64(keyInt)
        } else if let keyString = try? container.decode(String.self, forKey: .leagueKey), let keyInt = Int64(keyString) {
            leagueKey = keyInt
        } else {
            throw DecodingError.typeMismatch(
                Int64.self,
                DecodingError.Context(
                    codingPath: container.codingPath + [CodingKeys.leagueKey],
                    debugDescription: "league_key could not be decoded as Int64, Int, or convertible String"
                )
            )
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(leagueKey, forKey: .leagueKey)
        try container.encode(leagueName, forKey: .leagueName)
        try container.encode(leagueLogo, forKey: .leagueLogo)
        try container.encode(countryName, forKey: .countryName)
    }
}
