//
//  AboutViewController.swift
//  Cityzen
//
//  Created by Vladimir Cirkovic on 5/26/17.
//  Copyright © 2017 Vladimir Cirkovic. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    let helper = Helper.sharedInstance

    @IBAction func backButton(_ sender: UIButton) {
        helper.playSound(filename: "misc_menu_4.wav")
        self.dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var aboutLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
