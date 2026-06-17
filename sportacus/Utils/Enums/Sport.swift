//
//  Sport.swift
//  sportacus
//
//  Created by Mackbok bro on 02/06/2026.
//

import Foundation

enum Sport: String, CaseIterable {
    case football = "football"
    case basketball = "basketball"
    case cricket = "cricket"
    case tennis = "tennis"
    
    var displayName: String {
        switch self {
        case .football: return "Football"
        case .basketball: return "Basketball"
        case .cricket: return "Cricket"
        case .tennis: return "Tennis"
        }
    }
    
    var imageName: String {
        switch self {
        case .football: return "football_bg"
        case .basketball: return "basketball_bg"
        case .cricket: return "cricket_bg"
        case .tennis: return "tennis_bg"
        }
    }
}
