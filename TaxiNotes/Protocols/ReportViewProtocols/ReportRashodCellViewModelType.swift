//
//  ReportRashodCellViewModelType.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 21.11.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit

protocol ReportRashodCellViewModelType: class {
    var dateRashodLabel: String {get}
    var nameRashodLabel: String {get}
    var summaRashodLabel: String {get}
}
