//
//  MainViewController.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 28.10.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var topBar: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        topBar.title = Variables.sharedVariables.currentAccountName 
    }

}
