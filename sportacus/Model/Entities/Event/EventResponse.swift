//
//  EventResponse.swift
//  sportacus
//
//  Created by Noureldeen on 05/06/2026.
//

import Foundation

struct EventResponse: Codable {
    let success: Int
    let result: [APIEvent]?
}
