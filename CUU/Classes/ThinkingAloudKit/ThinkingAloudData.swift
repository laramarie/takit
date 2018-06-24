//
//  ThinkingAloudData.swift
//  thinkingaloud
//
//  Created by Lara Marie Reimer on 20.05.18.
//  Copyright © 2018 Lara Marie Reimer. All rights reserved.
//

import Foundation

protocol ThinkingAloudData: Codable {
    var thinkingAloudSessionId: String { get }
    var featureId: String { get }
    var previousCrumb: CUUCrumb { get }
    var nextCrumb: CUUCrumb? { get }
    var content: String { get }
    var timestamp: Date { get }
}
