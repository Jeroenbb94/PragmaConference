//
//  Speaker.swift
//  JBDiffableDataSource
//
//  Created by Jeroen Bakker on 21/09/2019.
//  Copyright © 2019 Jeroen Bakker. All rights reserved.
//

import Foundation

struct Speaker {
    private let identifier: UUID = UUID()
    
    let name: String
    let twitterHandler: String
    private(set) var imageURL: URL?
}

extension Speaker: Hashable {
    
    // Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    // Equatable - Inherited from Hashable
    static func == (lhs: Speaker, rhs: Speaker) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
