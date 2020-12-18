//
//  RashodViewCell.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 03.11.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit
import SwipeCellKit

class RashodViewCell: SwipeTableViewCell {
    @IBOutlet weak var nameRashodLabel: UILabel!
    @IBOutlet weak var summRashodLabel: UILabel!
    @IBOutlet weak var dateRashodLabel: UILabel!
    
    weak var viewModel: RashodViewCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else {return}
            nameRashodLabel.text = viewModel.nameRashodLabel
            summRashodLabel.text = "\(viewModel.summRashodLabel) ₽"
            dateRashodLabel.text = viewModel.dateRashodLabel
        }
    }
    
}
