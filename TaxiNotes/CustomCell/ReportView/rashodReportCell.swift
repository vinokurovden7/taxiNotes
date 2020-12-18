//
//  rashodReportCell.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 11.11.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit

class rashodReportCell: UITableViewCell {

    @IBOutlet weak var dateRashodLabel: UILabel!
    @IBOutlet weak var nameRashodLabel: UILabel!
    @IBOutlet weak var summaRashodLabel: UILabel!
    
    weak var viewModel: ReportRashodCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else {return}
            dateRashodLabel.text = viewModel.dateRashodLabel
            nameRashodLabel.text = viewModel.nameRashodLabel
            summaRashodLabel.text = viewModel.summaRashodLabel
        }
    }
}
