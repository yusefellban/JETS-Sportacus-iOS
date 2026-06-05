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
}
