//
//  AboutViewController.swift
//  Cityzen
//
//  Created by Vladimir Cirkovic on 5/26/17.
//  Copyright © 2017 Vladimir Cirkovic. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    @IBOutlet weak var label: UILabel!

    @IBAction func back(_ sender: UIButton) {

    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
