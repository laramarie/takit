//
//  ThinkingAloudController.swift
//  CUU
//
//  Created by Lara Marie Reimer on 27.05.18.
//  Copyright © 2018 Lara Marie Reimer. All rights reserved.
//

import Foundation
import UIKit

class ThinkingAloudController : ThinkingAloudStartViewControllerDelegate, ThinkingAloudSessionIndicatorDelegate {
    
    var recognitionManagers = [RecognitionManager]()
    
    var indicatorView : ThinkingAloudSessionIndicator = {
        let indicator = ThinkingAloudSessionIndicator()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    var indicatorTopConstraint = NSLayoutConstraint()
    
    var currentFeature: CUUFeature?
    
    var isActive = false
    
    var previousCrumbId: String?
    
    // MARK: - Lifecycle
    
    init() {
        // Register observer for feature crumbs.
        NotificationCenter.default.addObserver(self, selector: #selector(crumbReceived(notification:)), name: .didTriggerCrumb, object: nil)
    }
    
    // MARK: - Thinking Aloud Run Controlling

    @objc func crumbReceived(notification: NSNotification) {
        let payload = notification.userInfo
        
        let featureArray = CUUUserManager.sharedManager.completedThinkingAloudFeatures
        if let payload = payload,
            let feature = payload["feature"] as? CUUFeature,
            let isFirst = payload["isFirst"] as? Bool,
            let isLast = payload["isLast"] as? Bool,
            let crumbId = payload["crumbId"] as? String
        {
            if (true) { //!featureArray.contains(String(feature.id)) {
                if !isActive && isFirst && !isLast {
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        self.start()
                    }
                    currentFeature = feature
                    previousCrumbId = crumbId
                } else {
                    if let currentFeature = currentFeature {
                        if feature.id == currentFeature.id {
                            if (isLast) {
                                print(isLast)
                                stop()
                            } else {
                                stopRecording(isLast: false)
                                startRecording()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func start() {
        guard let feature = currentFeature else { return }
        
        let startVC = ThinkingAloudStartViewController()
        startVC.modalPresentationStyle = .overFullScreen
        startVC.delegate = self
        startVC.featureTitle = feature.name
        let currentVC = CUUUtils.getTopViewController()
        currentVC?.present(startVC, animated: true, completion: nil)
        
        isActive = true
    }
    
    func stop() {
        animateInOut(animateIn: false)
        
        self.stopRecording(isLast: true)
        
        isActive = false
        
        // Store it in user defaults
        if let id = currentFeature?.id {
            var featureArray = CUUUserManager.sharedManager.completedThinkingAloudFeatures
            featureArray.append(String(id))
            UserDefaults.standard.set(featureArray, forKey: CUUConstants.CUUUserDefaultsKeys.thinkingAloudFeaturesKey)
        }
    }
    
    func startRecording() {
        let manager = RecognitionManager()
        // Add it to managers array.
        self.recognitionManagers.append(manager)
        DispatchQueue.global().async {
            manager.recordAndRecognizeSpeech()
        }
    }
    
    func stopRecording(isLast: Bool) {
        if let manager = recognitionManagers.first {
            manager.stopRecording(isLast: isLast, with: { (result) in
                DispatchQueue.main.async {
                    if let previousCrumbId = self.previousCrumbId, let feature = self.currentFeature {
                        let dataObject = DefaultThinkingAloudRecognition(featureId: String(feature.id), previousCrumbId: previousCrumbId, content: result, analysis: "")
                        dataObject.send()
                    }
                }
                // Remove manager from array.
                self.recognitionManagers.removeFirst()
            })
        }
    }
    
    // MARK: - UI
    func showSessionIndicator() {
        guard let topVC = CUUUtils.getTopViewController(), let window = topVC.view.window else { return }
        
        indicatorView.delegate = self
        
        window.addSubview(indicatorView)
        
        //position constraints
        let viewsDictionary = ["indicator": indicatorView] as [String : Any]
        
        let hConstraintsIndicator = NSLayoutConstraint.constraints(withVisualFormat: "H:|[indicator]|", options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: viewsDictionary)
        indicatorTopConstraint = NSLayoutConstraint(item: indicatorView, attribute: .bottom, relatedBy:.equal, toItem: window, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        window.addConstraints(hConstraintsIndicator)
        window.addConstraint(indicatorTopConstraint)
        
        window.setNeedsUpdateConstraints();
        window.setNeedsLayout();
        window.layoutIfNeeded();
        
        animateInOut(animateIn: true)
    }
    
    func animateInOut(animateIn: Bool) {
        guard let topVC = CUUUtils.getTopViewController(), let window = topVC.view.window else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 0.3, animations: {
                let height = self.indicatorView.frame.height
                
                self.indicatorTopConstraint.constant = animateIn ? CGFloat(height) : 0.0
                
                window.setNeedsUpdateConstraints()
                window.setNeedsLayout()
                window.layoutIfNeeded()
            }, completion: { (completed) in
                if completed && !animateIn {
                    self.indicatorView.removeFromSuperview()
                }
            })
        }
    }
    
    // MARK: - ThinkingAloudStartViewControllerDelegate
    
    func thinkingAloudStartViewControllerDidPressStart() {
        RecognitionManager.checkAuthorizationAndStart { (granted) in
            if granted {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.showSessionIndicator()
                }
                self.startRecording()
            }
        }
    }
    
    // MARK: - ThinkingAloudSessionIndicatorDelegate
    
    func thinkingAloudIndicatorDidAbortSession() {
        guard let topVC = CUUUtils.getTopViewController() else { return }
        
        let alert = UIAlertController(title: "Abort current session", message: "Do you really want to stop the current Thinking Aloud session? No data will be sent in this case.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
            // Do nothing.
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            self.stop()
        }))
        topVC.present(alert, animated: true, completion: nil)
    }
}
