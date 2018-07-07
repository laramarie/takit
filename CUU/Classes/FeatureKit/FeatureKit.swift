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
    
    var activatedFeatures: [CUUFeature]? = []
    
    public func start() {
        // Get all activated features for this commit version.
        activatedFeaturesForCurrentCommit()
    }
    
    // MARK: Networking
    
    /*
    *   Method for retrieving activated features for the database.
    */
    func activatedFeaturesForCurrentCommit() {
        if let projectId = CUUConstants.projectId, let commitHash = CUUConstants.commitHash, let trackingToken = CUUConstants.trackingToken, let baseUrl = CUUConstants.baseUrl {
            // Construct the url.
            let urlString = baseUrl + "/v1/projects/" + projectId + "/commits/" + commitHash + "/activatedFeatures"
            let url = URL(string: urlString)
            
            // Create the url request.
            var urlRequest = URLRequest(url: url!)
            urlRequest.httpMethod = "GET"
            urlRequest.setValue(trackingToken, forHTTPHeaderField: "X-Tracking-Token")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Send the request.
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let data = data {
                    // Try to serialize crumb data.
                    do {
                        let decoder = JSONDecoder()
                        let features = try decoder.decode([CUUFeature].self, from: data)
                        self.activatedFeatures = features
                        print(self.activatedFeatures)
                    } catch {
                        print(error)
                    }
                } else {
                    print(error as Any)
                }
            }
            task.resume()
        }
    }
    
    // MARK: Helper Methods
    
    /*
    *   Checks if any action needs to be performed for the triggered crumb.
    *   @parameter crumb: the crumb fo which this action should be performed.
    */
    func handleAdditionalCrumbActionsForFeatures(with crumb: FKActionCrumb) {
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
    
    func feature(for crumb: FKActionCrumb) -> CUUFeature? {
        if let activatedFeatures = self.activatedFeatures {
            for feature in activatedFeatures {
                for featureCrumb in feature.steps {
                    if featureCrumb == crumb.name {
                        return feature
                    }
                }
            }
        }
        return nil
    }
    
    func isFirst(crumb: FKActionCrumb, in feature: CUUFeature) -> Bool {
        if feature.steps.count > 0 && feature.steps.first == crumb.name {
            return true
        }
        return false
    }
    
    func isLast(crumb: FKActionCrumb, in feature: CUUFeature) -> Bool {
        if feature.steps.count > 0 && feature.steps.last == crumb.name {
            return true
        }
        return false
    }
}
