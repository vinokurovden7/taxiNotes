//
//  HelpScreenViewController.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 26.11.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit

class HelpScreenViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switch Variables.sharedVariables.typeBtn {
        case 0:
            titleLabel.text = "Стоимость списания с заказа"
            textLabel.text = "Это сумма, которую списывает агрегатор со счета водителя за заказ."
        case 1:
            titleLabel.text = "Стоимость списания с заказа в %"
            textLabel.text = "Это процент от стоимости заказа, который списывает агрегатор со счета водителя."
        default:return
        }
        
    }

}
