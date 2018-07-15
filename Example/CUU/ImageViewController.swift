//
//  ImageViewController.swift
//  CUU_Example
//
//  Created by Lara Marie Reimer on 08.07.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import CUU

class ImageViewController: UIViewController {
    
    
    @IBAction func didTapGo(_ sender: UIButton) {
        CUU.seed(name: "DidTapGo")
    }
}
