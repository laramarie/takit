//
//  DoneViewController.swift
//  CUU_Example
//
//  Created by Lara Marie Reimer on 08.07.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import CUU

class DoneViewController: UIViewController {
    
    @IBAction func didTapDone(_ sender: Any) {
        CUU.seed(name: "DidTapDone")
        self.dismiss(animated: true, completion: nil)
    }
}
