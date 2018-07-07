//
//  DefaultThinkingAloudRecognition.swift
//  CUU
//
//  Created by Lara Marie Reimer on 03.07.18.
//

import Foundation

struct DefaultThinkingAloudRecognition: ThinkingAloudRecognition {
    let sessionId: String
    let userId: String
    let featureId: String
    let previousCrumb: FKActionCrumb
    let content: String
    let timestamp: Date
    let analysis: String
    
    init(featureId: String, previousCrumb: FKActionCrumb, content: String, analysis: String) {
        self.sessionId = "abcde"
        self.userId = CUUUserManager.sharedManager.userId
        self.featureId = featureId
        self.previousCrumb = previousCrumb
        self.content = content
        self.timestamp = Date()
        self.analysis = "{}"
    }
}
