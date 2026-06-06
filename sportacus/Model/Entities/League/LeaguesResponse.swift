//
//  LeaguesResponse.swift
//  sportacus
//
//  Created by Noureldeen on 05/06/2026.
//

import Foundation

struct LeaguesResponse: Codable {
    let success: Int
    let result: [League]?
    
    enum CodingKeys: String, CodingKey {
        case success
        case result
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let successInt = try? container.decode(Int.self, forKey: .success) {
            success = successInt
        } else if let successStr = try? container.decode(String.self, forKey: .success), let successInt = Int(successStr) {
            success = successInt
        } else {
            success = 0
        }
        
        if let array = try? container.decode([League].self, forKey: .result) {
            result = array
        } else {
            result = nil
        }
    }
}
