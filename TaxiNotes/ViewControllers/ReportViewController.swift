//
//  ReportViewController.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 03.11.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {

    private var arrayBarButtons: [UIBarButtonItem] = []
    @IBOutlet weak var changePeriodBtnItem: UIBarButtonItem!
    @IBOutlet weak var logoutBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayBarButtons.append(changePeriodBtnItem)
        arrayBarButtons.append(logoutBtn)
        Variables.sharedVariables.changeThemeViewController(viewController: self, arrayBarButtons: arrayBarButtons)
        navigationItem.title = Variables.sharedVariables.currentAccountName
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        Variables.sharedVariables.changeThemeViewController(viewController: self, arrayBarButtons: arrayBarButtons)
    }

}
