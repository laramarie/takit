//
//  CUUFeature.swift
//  CUU
//
//  Created by Lara Marie Reimer on 18.06.18.
//

import Foundation

public protocol CUUFeature : Codable {
    var name: String { get }
    var id: String { get }
    var crumbs: [CUUCrumb] { get }
    var additionalActionTypes: [String]? { get }
}
