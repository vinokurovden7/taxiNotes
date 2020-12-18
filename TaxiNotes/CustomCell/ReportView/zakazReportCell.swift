//
//  zakazReportCell.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 11.11.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit
import SwipeCellKit

class zakazReportCell: SwipeTableViewCell {

    @IBOutlet weak var dateZakazLabel: UILabel!
    @IBOutlet weak var nameZakazLabel: UILabel!
    @IBOutlet weak var summaZakazLabel: UILabel!
    
    weak var viewModel: ReportZakazCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else {return}
            dateZakazLabel.text = viewModel.dateZakazLabel
            nameZakazLabel.text = viewModel.nameZakazLabel
            summaZakazLabel.text = viewModel.summaZakazLabel
        }
    }
}
