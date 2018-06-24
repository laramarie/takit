//
//  ThinkingAloudSessionIndicator.swift
//  thinkingaloud
//
//  Created by Lara Marie Reimer on 27.05.18.
//  Copyright © 2018 Lara Marie Reimer. All rights reserved.
//

import UIKit

protocol ThinkingAloudSessionIndicatorDelegate : class {
    func thinkingAloudIndicatorDidAbortSession()
}

class ThinkingAloudSessionIndicator : UIView {
    
    var didSetupConstraints = false
    
    weak var delegate: ThinkingAloudSessionIndicatorDelegate?
    
    var indicator : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        return view
    }()
    
    var image : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.clear
        imageView.image = UIImage(named: "voice-recorder")
        return imageView
    }()
    
    var text : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.text = "Recording..."
        return label
    }()
    
    var abort : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "cancel"), for: .normal)
        button.addTarget(self, action: #selector(didTapAbort(sender:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.clear
        
        self.addSubview(indicator)
        self.indicator.addSubview(image)
        self.indicator.addSubview(text)
        self.indicator.addSubview(abort)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Autolayout
    
    override func updateConstraints() {
        if(!didSetupConstraints) {
            // AutoLayout constraints
            didSetupConstraints = true
            
            var topSafeArea = CGFloat(20)
            
            if #available(iOS 11.0, *) {
                let window = UIApplication.shared.keyWindow
                if let top = window?.safeAreaInsets.top {
                    if top > CGFloat(0.0) {
                        topSafeArea = top
                    }
                }
            }
            
            //position constraints
            let viewsDictionary = ["background": indicator, "image": image, "text": text, "abort": abort] as [String : Any]
            let metrics = ["top": topSafeArea] as [String : Any]
            
            let hConstraintsBackground = NSLayoutConstraint.constraints(withVisualFormat: "H:|[background]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
            let vConstraintsBackground = NSLayoutConstraint.constraints(withVisualFormat: "V:|[background]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
            let hConstraintsContent = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[image(25)]-(>=10)-[text]-(>=10)-[abort(25)]-10-|", options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: viewsDictionary)
            let heightImage = NSLayoutConstraint.constraints(withVisualFormat: "V:|-top-[image(25)]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: viewsDictionary)
            let heightButton = NSLayoutConstraint.constraints(withVisualFormat: "V:|-top-[abort(25)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: viewsDictionary)
            let centerTextX = NSLayoutConstraint(item: text, attribute: .centerX, relatedBy:.equal, toItem: indicator, attribute: .centerX, multiplier: 1.0, constant: 1.0)
            let centerTextY = NSLayoutConstraint(item: text, attribute: .centerY, relatedBy:.equal, toItem: abort, attribute: .centerY, multiplier: 1.0, constant: 1.0)
            
            addConstraints(hConstraintsBackground)
            addConstraints(vConstraintsBackground)
            addConstraints(hConstraintsContent)
            addConstraint(centerTextX)
            addConstraint(centerTextY)
            addConstraints(heightImage)
            addConstraints(heightButton)
        }
        super.updateConstraints()
    }
    
    @objc func didTapAbort(sender: UIButton) {
        guard let delegate = delegate else { return }
        delegate.thinkingAloudIndicatorDidAbortSession()
    }
}
