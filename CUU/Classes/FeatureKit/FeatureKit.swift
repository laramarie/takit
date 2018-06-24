//
//  FeatureKit.swift
//  CUU
//
//  Created by Lara Marie Reimer on 10.12.17.
//

import Foundation

/**
 *  Open class to exhibit FeatureKit behavior.
 **/
open class FeatureKit {
    
    var activatedFeatures: [CUUFeature]?
    
    public func start() {
        // Get all activated features for this commit version.
        activatedFeatures = activatedFeaturesForCurrentCommit()
    }
    
    /**
    *   Open method to handle crumb saving.
    *   @param name: the name of the crumb to be created and stored
    **/
    open static func seed(name: String) {
        let actionCrumb = FKActionCrumb(name: name)
        actionCrumb.send()
        
        
    }
    
    func activatedFeaturesForCurrentCommit() -> [CUUFeature]? {
        if let commit = CUUConstants.commitHash {
            // TODO: Check for activated features in the database.
            
            return []
        }
        
        return nil
    }
    
    func handleAdditionalCrumbActionsForFeatures(with crumb: CUUCrumb) {
        // Check if any additional actions should be performed on CUU.
        if let correspondingActivatedFeature = feature(for: crumb) {
            // Dispatch a notification that a new feature crumb was triggered.
            let payload = ["crumb": crumb,
                           "isFirst": isFirst(crumb: crumb, in: correspondingActivatedFeature),
                           "isLast": isLast(crumb: crumb, in: correspondingActivatedFeature),
                           "featureId": correspondingActivatedFeature.id
                ] as [String : Any]
            let notification = Notification.init(name: Notification.Name(rawValue: "de.tum.in.ase.cuu.featurekit.didTriggerFeatureCrumb"), object: nil, userInfo: payload)
            NotificationCenter.default.post(notification)
        }
    }
    
    func feature(for crumb: CUUCrumb) -> CUUFeature? {
        if let activatedFeatures = self.activatedFeatures {
            for feature in activatedFeatures {
                for featureCrumb in feature.crumbs {
                    if featureCrumb.name == crumb.name {
                        return feature
                    }
                }
            }
        }
        return nil
    }
    
    func isFirst(crumb: CUUCrumb, in feature: CUUFeature) -> Bool {
        if feature.crumbs.count > 0 && feature.crumbs.first?.name == crumb.name {
            return true
        }
        return false
    }
    
    func isLast(crumb: CUUCrumb, in feature: CUUFeature) -> Bool {
        if feature.crumbs.count > 0 && feature.crumbs.last?.name == crumb.name {
            return true
        }
        return false
    }
}
